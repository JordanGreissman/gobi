test:
		ocamlbuild -cflags -g -pkgs oUnit,yojson,lwt,camomile,lambda-term test/run_tests.byte && ./run_tests.byte

clean:
		ocamlbuild -clean

game:
		ocamlbuild -pkgs yojson,lwt,camomile,lambda-term src/game.byte && mv game.byte gobi && ./gobi

.PHONY: test
