#ifndef OUTPUT_H
#define OUTPUT_H

#include <stdio.h>
#include <stdarg.h>

static int default_print(const char *format, ...)
{
  va_list args;
  va_start(args, format);
  int result = vprintf(format, args);
  va_end(args);
  return result;
}

#endif /* OUTPUT_H */