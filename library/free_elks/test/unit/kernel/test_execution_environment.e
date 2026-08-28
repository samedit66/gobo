note

	description:

		"Test features of class EXECUTION_ENVIRONMENT"

	library: "FreeELKS Library"
	copyright: "Copyright (c) 2018, Eric Bezault and others"
	license: "MIT License"

class TEST_EXECUTION_ENVIRONMENT

inherit

	TS_TEST_CASE
	
create

	make_default

feature -- Test

	test_starting_environment
			-- Test feature 'starting_environment'.
		local
			l_execution_environment: EXECUTION_ENVIRONMENT
			l_starting_environment: HASH_TABLE [STRING_32, STRING_32]
			l_gobo_variable, l_test_variable: STRING_32
		do
			create l_execution_environment
			create l_gobo_variable.make_from_string ("GOBO")
			create l_test_variable.make_from_string ("GOBO_FREE_ELKS_TEST_STARTING_ENVIRONMENT")
			l_starting_environment := l_execution_environment.starting_environment
			assert_true ("has_gobo", l_starting_environment.has (l_gobo_variable))
			assert_false ("test_variable_not_in_starting_environment", l_starting_environment.has (l_test_variable))
			l_execution_environment.put ("set after process start", l_test_variable)
			assert_true ("current_environment_updated", attached l_execution_environment.item (l_test_variable) as l_value and then l_value.same_string_general ("set after process start"))
			assert_false ("starting_environment_unchanged", l_execution_environment.starting_environment.has (l_test_variable))
			l_execution_environment.put ("", l_test_variable)
		end

	test_available_cpu_count
			-- Test feature 'available_cpu_count'.
		local
			l_execution_environment: EXECUTION_ENVIRONMENT
		do
			create l_execution_environment
			assert_true ("at_least_one_cpu", l_execution_environment.available_cpu_count >= 1)
		end

end
