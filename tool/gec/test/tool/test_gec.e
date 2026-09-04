note

	description:

		"Test 'gec'"

	copyright: "Copyright (c) 2006-2025, Eric Bezault and others"
	license: "MIT License"

class TEST_GEC

inherit

	EIFFEL_TOOL_TEST_CASE

create

	make_default

feature -- Access

	program_name: STRING = "gec"
			-- Program name

feature -- Test

	test_gec
			-- Test 'gec'.
		do
			compile_program
			check_build_flavor
			if eiffel_compiler.is_ge and then not variables.has ("debug") then
				run_validation
			end
		end

feature {NONE} -- Test

	check_build_flavor
			-- Check that help and version output identify the patched build and behavior.
		do
			assert_execute_with_command_output (program_exe + " --version" + output2_log, output2_log_filename, error2_log_filename)
			assert_file_contains ("version_build_flavor", output2_log_filename, Build_flavor)
			assert_execute_with_command_output (program_exe + " --help" + output3_log, output3_log_filename, error3_log_filename)
			assert_file_contains ("help_build_flavor", output3_log_filename, Build_flavor)
			assert_file_contains ("help_local_behavior", output3_log_filename, "Local behavior:")
			assert_file_contains ("help_starting_environment", output3_log_filename, "EXECUTION_ENVIRONMENT.starting_environment")
		end

	assert_file_contains (a_tag, a_filename, a_text: STRING)
			-- Assert that file `a_filename' contains `a_text'.
		require
			a_tag_not_void: a_tag /= Void
			a_filename_not_void: a_filename /= Void
			a_text_not_void: a_text /= Void
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_with_name (a_filename)
			l_file.open_read
			if l_file.is_open_read then
				l_file.read_stream (l_file.count)
				assert (a_tag, l_file.last_string.has_substring (a_text))
				l_file.close
			else
				assert (a_tag + "_file_readable", False)
			end
		end

	Build_flavor: STRING = "samedit66 patched build"
			-- Identifier expected in command-line information.

end
