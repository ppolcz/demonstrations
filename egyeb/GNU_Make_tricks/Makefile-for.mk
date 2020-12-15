
SUBDIRS = foo bar baz
subdirs:
    @for dir in $(SUBDIRS); do \
        echo $$dir; \
    done

proba:
    $(call define_varname,valami/itk/ppke/hu)

define define_varname
    $(eval varname := $(patsubst valami/itk/%,kutyagumi/%,$(1)))
    @echo $(varname)
endef
