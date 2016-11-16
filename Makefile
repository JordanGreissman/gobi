test:
		ocamlbuild -cflags -g -pkgs oUnit,ANSITerminal,yojson test/run_tests.byte && ./run_tests.byte

clean:
		ocamlbuild -clean

game:
		ocamlbuild -pkgs ANSITerminal,yojson src/main.byte && mv main.byte gooby

.PHONY: test
