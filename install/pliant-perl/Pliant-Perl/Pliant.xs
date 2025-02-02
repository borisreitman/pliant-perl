#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <pliant.h>

#include "const-c.inc"

MODULE = Inline::Pliant		PACKAGE = Inline::Pliant

INCLUDE: const-xs.inc

void
pliant_compile(source_code)
	char *	source_code

void
pliant_load()
