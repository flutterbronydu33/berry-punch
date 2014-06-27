cmake_minimum_required (VERSION 2.8)

# Utilities
#include ()
#set (CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")

# Global
set (global_c_flags_debug	"-g -Wall")
set (global_c_flags_release	"-s -O2")

# Usefull variables
set (root_dir ${CMAKE_CURRENT_SOURCE_DIR})
set (src_in_dir ${root_dir}/src)
set (include_in_dir ${root_dir}/include)
set (bin_out_dir ${root_dir}/bin)
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY	${bin_out_dir})

# Main project
project(berrypunch)

	# Sources & flags
	file (GLOB_RECURSE sources ${src_in_dir}/*.c)
	file (GLOB_RECURSE headers ${include_in_dir}/${PROJECT_NAME}/*.h)
	set	(CMAKE_C_FLAGS_DEBUG ${global_c_flags_debug})
	set	(CMAKE_C_FLAGS_RELEASE ${global_c_flags_release})
	include_directories (${include_in_dir})

	# Config
	add_definitions (-DVERSION_MAJ=0 -DVERSION_MIN=0 -DVERSION_REL=1 )

	# Build app
	add_executable (${PROJECT_NAME} ${sources} ${headers})
	target_link_libraries (${PROJECT_NAME} -lircclient)
