const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const xar = b.addStaticLibrary(.{
        .name = "xar",
        .root_source_file = null,
        .target = target,
        .optimize = optimize,
    });
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
    }, &[_][]const u8{});
    xar.addIncludePath("xar/xar/include");
    xar.addIncludePath("/usr/include");
    xar.addIncludePath("/usr/include/libxml2");
    xar.addIncludePath("/usr/include/x86_64-linux-gnu");
    xar.defineCMacro("_GNU_SOURCE", "1");

    xar.addLibraryPath("/usr/lib/x86_64-linux-gnu");
    xar.linkSystemLibrary("lzma");
    xar.linkSystemLibrary("bz2");
    xar.linkSystemLibrary("z");
    xar.linkSystemLibrary("crypto");
    xar.linkSystemLibrary("xml2");
    xar.linkLibC();
    b.installArtifact(xar);

    b.installDirectory(std.build.InstallDirectoryOptions{
        .source_dir = "xar/xar/include",
        .install_dir = .header,
        .install_subdir = "xar",
    });

    const xarexe = b.addExecutable(.{
        .name = "xar",
        .root_source_file = null,
        .target = target,
        .optimize = optimize,
    });
    xarexe.addCSourceFile("xar/xar/src/xar.c", &[_][]const u8{});
    xarexe.addIncludePath("xar/xar/include");
    xarexe.addIncludePath("/usr/include");
    xarexe.addIncludePath("/usr/include/libxml2");
    xarexe.addIncludePath("/usr/include/x86_64-linux-gnu");
    xarexe.defineCMacro("_GNU_SOURCE", "1");

    xarexe.addLibraryPath("zig-out/lib");
    xarexe.addLibraryPath("/usr/lib/x86_64-linux-gnu");
    xarexe.linkSystemLibrary("xml2");
    xarexe.linkSystemLibrary("z");
    xarexe.linkSystemLibrary("crypto");
    xarexe.linkSystemLibrary("lzma");
    xarexe.linkSystemLibrary("bz2");
    xarexe.linkLibrary(xar);

    xarexe.linkLibC();
    b.installArtifact(xarexe);

    const exe = b.addExecutable(.{
        .name = "pbxz",
        .root_source_file = null,
        .target = target,
        .optimize = optimize,
    });
    exe.addCSourceFile("pbzx/pbzx.c", &[_][]const u8{});
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
    exe.linkLibrary(xar);
    exe.linkLibC();
    b.installArtifact(exe);
}
