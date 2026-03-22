test_all:
  ruby -Itest test/all_tests.rb

test TEST: 
  find test/ -type f -name "*{{TEST}}*.rb" \
    |xargs -I{} sh -c 'echo "=== Running {} ==="; ruby -Itest "{}"'
