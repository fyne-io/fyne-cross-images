const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const xar = b.addStaticLibrary(.{
        .name = "xar",
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
    xar.addIncludePath(.{ .path = "xar/xar/include" });
    xar.addIncludePath(.{ .path = "/usr/include" });
    xar.addIncludePath(.{ .path = "/usr/include/libxml2" });
    xar.addIncludePath(.{ .path = "/usr/include/x86_64-linux-gnu" });
    xar.defineCMacro("_GNU_SOURCE", "1");

    xar.addLibraryPath(.{ .path = "/usr/lib/x86_64-linux-gnu" });
    xar.linkSystemLibrary("lzma");
    xar.linkSystemLibrary("bz2");
    xar.linkSystemLibrary("z");
    xar.linkSystemLibrary("crypto");
    xar.linkSystemLibrary("xml2");
    xar.linkLibC();
    b.installArtifact(xar);

    b.installDirectory(std.build.InstallDirectoryOptions{
        .source_dir = .{ .path = "xar/xar/include" },
        .install_dir = .header,
        .install_subdir = "xar",
    });

    const xarexe = b.addExecutable(.{
        .name = "xar",
        .target = target,
        .optimize = optimize,
    });
    xarexe.addCSourceFile(.{
        .file = .{ .path = "xar/xar/src/xar.c" },
        .flags = &[_][]const u8{},
    });
    xarexe.addIncludePath(.{ .path = "xar/xar/include" });
    xarexe.addIncludePath(.{ .path = "/usr/include" });
    xarexe.addIncludePath(.{ .path = "/usr/include/libxml2" });
    xarexe.addIncludePath(.{ .path = "/usr/include/x86_64-linux-gnu" });
    xarexe.defineCMacro("_GNU_SOURCE", "1");

    xarexe.linkLibrary(xar);
    xarexe.addLibraryPath(.{ .path = "/usr/lib/x86_64-linux-gnu" });
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
        .target = target,
        .optimize = optimize,
    });
    exe.addCSourceFile(.{
        .file = .{ .path = "pbzx/pbzx.c" },
        .flags = &[_][]const u8{},
    });
    exe.addIncludePath(.{ .path = "zig-out/include" });
    exe.addIncludePath(.{ .path = "/usr/include" });
    exe.addIncludePath(.{ .path = "/usr/include/x86_64-linux-gnu" });

    exe.linkLibrary(xar);
    exe.addLibraryPath(.{ .path = "/usr/lib/x86_64-linux-gnu" });
    exe.linkSystemLibrary("xml2");
    exe.linkSystemLibrary("z");
    exe.linkSystemLibrary("crypto");
    exe.linkSystemLibrary("bz2");
    exe.linkSystemLibrary("lzma");
    exe.linkLibrary(xar);
    exe.linkLibC();
    b.installArtifact(exe);
}
