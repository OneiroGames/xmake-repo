package("vuk")
    set_homepage("https://github.com/martty/vuk")
    set_description("A rendergraph-based abstraction for Vulkan")
    set_license("MIT")

    add_urls("https://github.com/martty/vuk/archive/$(version).tar.gz",
             "https://github.com/martty/vuk.git")

    -- TODO: Add configs

    add_deps("cmake")

    on_install("macosx", "windows", "linux", "mingw", function (package)
        for _, file in ipairs(os.files("include/vuk/*.hpp")) do
            io.replace(file, "../src/", "")
        end
        os.cp("src/CreateInfo.hpp", "include/vuk/")
        local xmake_lua = [[
            add_rules("mode.debug", "mode.release")
            add_requires("plf_colony", "robin-hood-hashing", "fmt", "concurrentqueue", "vulkan-memory-allocator", "vulkansdk", "spirv-cross", {configs = {shared = true}})
            target("vuk")
                set_languages("c++20")
                set_kind("static")
                add_includedirs("include/", {public = true})
                add_headerfiles("include/vuk/*.hpp")
                add_files("src/.*cpp")
                add_defines("VUK_USE_SHADERC=0", "VUK_USE_DXC=0")
                add_defines("NOMINMAX", "VC_EXTRALEAN", "WIN32_LEAN_AND_MEAN", "_CRT_SECURE_NO_WARNINGS", "_SCL_SECURE_NO_WARNINGS", "_SILENCE_CLANG_CONCEPTS_MESSAGE", "_SILENCE_CXX23_ALIGNED_STORAGE_DEPRECATION_WARNING", {public = true})
                add_packages("plf_colony", "hood", "fmt", "concurrentqueue", "vulkan-memory-allocator", "vulkansdk", "spirv-cross", {public = true})
        ]]
        io.writefile("xmake.lua", xmake_lua)
        import("package.tools.xmake").install(package)
        
        os.cp("include", package:installdir())
        os.cp("src/CreateInfo.hpp", package:installdir() .. "/include/vuk/")
    end)
