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
			check_utf8_source
		end

feature {NONE} -- Test

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

end
