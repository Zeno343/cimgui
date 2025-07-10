const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const imgui = b.dependency("imgui", .{});

    // Build imgui
    const root = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libcpp = true,
    });
    root.addIncludePath(imgui.path(""));
    root.addIncludePath(imgui.path("backends"));
    root.addCSourceFiles(.{
        .root = imgui.path(""),
        .flags = &.{"-DIMGUI_IMPL_API=extern \"C\" "},
        .files = &.{
            "imgui.cpp",
            "imgui_tables.cpp",
            "imgui_draw.cpp",
            "imgui_demo.cpp",
            "imgui_widgets.cpp",
            "backends/imgui_impl_sdl3.cpp",
            "backends/imgui_impl_opengl3.cpp",
        },
    });
    root.addCSourceFiles(.{
        .files = &.{
            "cimgui.cpp",
        },
    });

    // Build library
    const lib = b.addLibrary(.{
        .name = "cimgui",
        .root_module = root,
    });
    lib.linkSystemLibrary("sdl3");

    // Install
    b.installArtifact(lib);
    lib.installHeader(b.path("cimgui_impl.h"), "cimgui_impl.h");
    lib.installHeader(b.path("cimgui.h"), "cimgui.h");
}
