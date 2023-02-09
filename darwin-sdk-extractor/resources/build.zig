const std = @import("std");

pub fn build(b: *std.build.Builder) void {

    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();
    const xar = b.addStaticLibrary("xar", null);
    xar.setBuildMode(mode);
    xar.setTarget(target);
    xar.addCSourceFiles(&.{
        "xar/xar/lib/archive.c",
        "xar/xar/lib/arcmod.c",
        "xar/xar/lib/b64.c",
        "xar/xar/lib/bzxar.c",
        "xar/xar/lib/darwinattr.c",
        "xar/xar/lib/data.c",
        "xar/xar/lib/ea.c",
        "xar/xar/lib/err.c",
        "xar/xar/lib/ext2.c",
        "xar/xar/lib/fbsdattr.c",
        "xar/xar/lib/filetree.c",
        "xar/xar/lib/hash.c",
        "xar/xar/lib/io.c",
        "xar/xar/lib/linuxattr.c",
        "xar/xar/lib/lzmaxar.c",
        "xar/xar/lib/macho.c",
        "xar/xar/lib/script.c",
        "xar/xar/lib/signature.c",
        "xar/xar/lib/stat.c",
        "xar/xar/lib/subdoc.c",
        "xar/xar/lib/util.c",
        "xar/xar/lib/zxar.c",
    }, &[_][]const u8 {});
    xar.addIncludePath("xar/xar/include");
    xar.addIncludePath("/usr/include");
    xar.addIncludePath("/usr/include/libxml2");
    xar.addIncludePath("/usr/include/x86_64-linux-gnu");

    xar.addLibraryPath("/usr/lib/x86_64-linux-gnu");
    xar.linkSystemLibrary("lzma");
    xar.linkSystemLibrary("bz2");
    xar.linkSystemLibrary("z");
    xar.linkSystemLibrary("crypto");
    xar.linkSystemLibrary("xml2");
    xar.linkLibC();
    xar.install();

    b.installDirectory(std.build.InstallDirectoryOptions{
        .source_dir = "xar/xar/include",
        .install_dir = .header,
        .install_subdir = "xar",
    });

    const xarexe = b.addExecutable("xar", null);
    xarexe.setBuildMode(mode);
    xarexe.setTarget(target);
    xarexe.addCSourceFile("xar/xar/src/xar.c", &[_][]const u8 {});
    xarexe.addIncludePath("xar/xar/include");
    xarexe.addIncludePath("/usr/include");
    xarexe.addIncludePath("/usr/include/libxml2");

    xarexe.addIncludePath("/usr/include/x86_64-linux-gnu");

    xarexe.addLibraryPath("zig-out/lib");
    xarexe.addLibraryPath("/usr/lib/x86_64-linux-gnu");
    xarexe.linkSystemLibrary("xml2");
    xarexe.linkSystemLibrary("z");
    xarexe.linkSystemLibrary("crypto");
    xarexe.linkSystemLibrary("lzma");
    xarexe.linkSystemLibrary("bz2");
    xarexe.linkSystemLibrary("xar");
    
    xarexe.linkLibC();
    xarexe.install();

    const exe = b.addExecutable("pbxz", null);
    exe.setTarget(target);
    exe.addCSourceFile("pbzx/pbzx.c", &[_][]const u8 {});
    exe.addIncludePath("zig-out/include");
    exe.addIncludePath("/usr/include");
    exe.addIncludePath("/usr/include/x86_64-linux-gnu");
    
    exe.addLibraryPath("/usr/lib/x86_64-linux-gnu");
    exe.addLibraryPath("zig-out/lib");
    exe.linkSystemLibrary("xml2");
    exe.linkSystemLibrary("z");
    exe.linkSystemLibrary("crypto");
    exe.linkSystemLibrary("bz2");
    exe.linkSystemLibrary("lzma");
    exe.linkSystemLibrary("xar");
    exe.linkLibC();
    exe.install();
}
