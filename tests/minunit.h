#undef NDEBUG
#ifndef _minunit_h
#define _minunit_h

#include <stdio.h>
#include <stdlib.h>

#include "dbg.h"

#define mu_suite_start() char *message = NULL

#define mu_assert(test, message) if (!(test)) {\
  log_err(message); return message; }

#define mu_run_test(test) printf("----- RUNNING TEST:%s\n", " " #test);\
  message = test(); tests_run++; if (message) return message;

#define RUN_TESTS(name) int main(int argc, char *argv[]) {\
  argc = 1;\
  printf("%s: RUNNING...\n", argv[0]);\
  char *result = name();\
  if (result != 0) {\
    printf("%s: FAILED: %s\n", argv[0], result);\
  }\
  else {\
    printf("%s: ALL TESTS PASSED\n", argv[0]);\
  }\
  printf("%s: TESTS RUN: %d\n", argv[0], tests_run);\
  exit(result != 0);\
}

int tests_run;

#endif
