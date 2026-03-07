test_all:
  ruby -Itest test/all_tests.rb

test TEST: 
  find test/ -type f -name "*{{TEST}}*.rb" |xargs -I{} ruby -Itest {}
