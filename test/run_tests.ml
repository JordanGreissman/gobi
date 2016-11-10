open OUnit2

let suite = "Project test suite" >:::
            Test_map.tests

let _ = run_test_tt_main suite


