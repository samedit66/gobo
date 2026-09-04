note

	description:

		"Test 'gedoc'"

	copyright: "Copyright (c) 2017, Eric Bezault and others"
	license: "MIT License"

class TEST_GEDOC

inherit

	TOOL_TEST_CASE

create

	make_default

feature -- Access

	program_name: STRING = "gedoc"
			-- Program name

feature -- Test

	test_gedoc
			-- Test 'gedoc'.
		do
			compile_program
			check_build_flavor
			check_utf8_source
		end

feature {NONE} -- Test

	check_build_flavor
			-- Check that help and version output identify the patched build.
		do
			assert_execute_with_command_output (program_exe + " --version" + output2_log, output2_log_filename, error2_log_filename)
			assert_file_contains ("version_build_flavor", output2_log_filename, Build_flavor)
			assert_execute_with_command_output (program_exe + " --help" + output3_log, output3_log_filename, error3_log_filename)
			assert_file_contains ("help_build_flavor", output3_log_filename, Build_flavor)
		end

	check_utf8_source
			-- Check that pretty-printing preserves BOM-less UTF-8 source text.
		local
			l_output_directory: STRING
			l_second_output_directory: STRING
			l_output_filename: STRING
			l_second_output_filename: STRING
		do
			l_output_directory := "output"
			l_second_output_directory := "output2"
			file_system.create_directory (l_output_directory)
			file_system.create_directory (l_second_output_directory)
			assert_execute_with_command_output (program_exe + " --force --output=" + l_output_directory + " " + utf8_source_filename + output2_log, output2_log_filename, error2_log_filename)
			l_output_filename := file_system.pathname (l_output_directory, "gedoc_utf8_source.e")
			assert_files_equal ("utf8_source_preserved", utf8_source_filename, l_output_filename)
			assert_execute_with_command_output (program_exe + " --force --output=" + l_second_output_directory + " " + l_output_filename + output3_log, output3_log_filename, error3_log_filename)
			l_second_output_filename := file_system.pathname (l_second_output_directory, "gedoc_utf8_source.e")
			assert_files_equal ("utf8_source_idempotent", l_output_filename, l_second_output_filename)
		end

	utf8_source_filename: STRING
			-- Name of BOM-less UTF-8 source file.
		once
			Result := file_system.nested_pathname ("${GOBO}", <<"tool", "gedoc", "test", "tool", "data", "gedoc_utf8_source.e">>)
			Result := Execution_environment.interpreted_string (Result)
		ensure
			utf8_source_filename_not_void: Result /= Void
			utf8_source_filename_not_empty: not Result.is_empty
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
