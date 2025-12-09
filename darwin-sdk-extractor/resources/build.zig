const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // ---- libxar (static) ----
    const xar_mod = b.createModule(.{
        .root_source_file = null, // C-only library
        .target = target,
        .optimize = optimize,
    });

    const xar = b.addLibrary(.{
        .name = "xar",
        .root_module = xar_mod,
        .linkage = .static,
    });

    xar.addCSourceFiles(.{
        .files = &.{
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
        },
        .flags = &.{},
    });

    // Include paths / defines
    xar.addIncludePath(b.path("xar/xar/include"));
    xar.addIncludePath(.{ .cwd_relative = "/usr/include" });
    xar.addIncludePath(.{ .cwd_relative = "/usr/include/libxml2" });
    xar.addIncludePath(.{ .cwd_relative = "/usr/include/x86_64-linux-gnu" });
    xar.root_module.addCMacro("_GNU_SOURCE", "1");

    // Link system libs needed by libxar
    xar.addLibraryPath(.{ .cwd_relative = "/usr/lib/x86_64-linux-gnu" });
    xar.linkSystemLibrary("lzma");
    xar.linkSystemLibrary("bz2");
    xar.linkSystemLibrary("z");
    xar.linkSystemLibrary("crypto");
    xar.linkSystemLibrary("xml2");
    xar.linkLibC();

    b.installArtifact(xar);

    // Install public headers to zig-out/include/xar
    b.installDirectory(.{
        .source_dir = b.path("xar/xar/include"),
        .install_dir = .header,
        .install_subdir = "xar",
    });

    // ---- xar CLI ----
    const xarexe = b.addExecutable(.{
        .name = "xar",
        .root_module = b.createModule(.{
            .root_source_file = null, // C-only exe
            .target = target,
            .optimize = optimize,
        }),
    });

    xarexe.addCSourceFile(.{
        .file = b.path("xar/xar/src/xar.c"),
        .flags = &.{},
    });
    xarexe.addIncludePath(b.path("xar/xar/include"));
    xarexe.addIncludePath(.{ .cwd_relative = "/usr/include" });
    xarexe.addIncludePath(.{ .cwd_relative = "/usr/include/libxml2" });
    xarexe.addIncludePath(.{ .cwd_relative = "/usr/include/x86_64-linux-gnu" });
    xarexe.root_module.addCMacro("_GNU_SOURCE", "1");

    xarexe.addLibraryPath(.{ .cwd_relative = "/usr/lib/x86_64-linux-gnu" });
    xarexe.linkSystemLibrary("xml2");
    xarexe.linkSystemLibrary("z");
    xarexe.linkSystemLibrary("crypto");
    xarexe.linkSystemLibrary("lzma");
    xarexe.linkSystemLibrary("bz2");
    xarexe.linkLibrary(xar);
    xarexe.linkLibC();

    b.installArtifact(xarexe);

    // ---- pbxz tool ----
    const pbxz = b.addExecutable(.{
        .name = "pbxz",
        .root_module = b.createModule(.{
            .root_source_file = null, // C-only exe
            .target = target,
            .optimize = optimize,
        }),
    });

    pbxz.addCSourceFile(.{
        .file = b.path("pbzx/pbzx.c"),
        .flags = &.{},
    });
    // Use installed headers from the lib build
    pbxz.addIncludePath(b.path("zig-out/include"));
    pbxz.addIncludePath(.{ .cwd_relative = "/usr/include" });
    pbxz.addIncludePath(.{ .cwd_relative = "/usr/include/x86_64-linux-gnu" });

    pbxz.addLibraryPath(.{ .cwd_relative = "/usr/lib/x86_64-linux-gnu" });
    pbxz.linkSystemLibrary("xml2");
    pbxz.linkSystemLibrary("z");
    pbxz.linkSystemLibrary("crypto");
    pbxz.linkSystemLibrary("bz2");
    pbxz.linkSystemLibrary("lzma");
    pbxz.linkLibrary(xar);
    pbxz.linkLibC();

    b.installArtifact(pbxz);
}
