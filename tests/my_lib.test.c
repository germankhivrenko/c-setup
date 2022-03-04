#include <dlfcn.h>

#include "dbg.h"
#include "minunit.h"
#include "my_lib.h"

typedef int (*lib_func) ();

char *test_func()
{
  int rc = func();
  mu_assert(rc == 0, "Return code is different from 0.");

  return NULL;
}

char *test_func_dyn()
{
  const char *lib_file = "build/my_lib.so";
  const char *func_name = "func";

  void *lib = dlopen(lib_file, RTLD_NOW);
  mu_assert(lib != NULL, "Failed to open the library.");

  lib_func func = dlsym(lib, func_name);
  mu_assert(func != NULL, "Could not find the function.");

  int rc = func();
  mu_assert(rc == 0, "Return code is different from 0.");

  return NULL;
}

char *fail_on_purpose()
{
  int rc = func();
  mu_assert(rc != 0, "Successfully failed.");

  return NULL;
}

char *all_tests()
{
  mu_suite_start();

  mu_run_test(test_func);
  mu_run_test(test_func_dyn);
  mu_run_test(fail_on_purpose);

  return NULL;
}

RUN_TESTS(all_tests);
