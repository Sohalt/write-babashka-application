{
  outputs = { ... }:
    {
      overlays.default = final: prev: {
        writeBabashkaApplication =
          { name
          , text
          , runtimeInputs ? [ ]
          , checkPhase ? null
          }:
          let
            script = final.writeText "script.clj" text;
          in
          final.writeShellApplication {
            inherit name runtimeInputs;
            text = ''
              ${final.babashka}/bin/bb ${script}
            '';
            checkPhase = ''
              ${final.clj-kondo}/bin/clj-kondo ${script}
            '';
          };
      };
    };
}
