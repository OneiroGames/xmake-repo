package("physfs")
    set_homepage("https://icculus.org/physfs/")
    set_description("A portable, flexible file i/o abstraction.")
    set_license("zlib")

    add_urls("https://github.com/icculus/physfs/archive/$(version).tar.gz",
             "https://github.com/icculus/physfs.git")

    -- TODO: Add configs

    add_deps("cmake")

    on_load(function (package)
    end)

    on_install("macosx", "windows", "linux", "mingw", function (package)
        local configs = {"-DPHYSFS_BUILD_DOCS=OFF -DPHYSFS_DISABLE_INSTALL=ON -DPHYSFS_BUILD_TEST=OFF"}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        if package:is_plat("windows") then
            table.insert(configs, "-DUSE_MSVC_RUNTIME_LIBRARY_DLL=" .. (package:config("vs_runtime"):startswith("MT") and "OFF" or "ON"))
        end
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
    end)