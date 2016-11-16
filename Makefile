test:
		ocamlbuild -cflags -g -pkgs oUnit,ANSITerminal test/run_tests.byte && ./run_tests.byte

clean:
		ocamlbuild -clean

.PHONY: test
