{ pkgs, projectId, ... }:
{
  bootstrap = ''
    cp -rf ${./.} "$out/"
    chmod -R +w "$out"

    # Apply project ID to configs
    if [ !-z $bootstrapjs ]
    then
      sed -e 's/<project-id>/${projectId}/' ${.idx/dev.nix} | sed -e 's/terraform init/# skip/' | sed -e 's/terraform apply/# skip/' > "$out/.idx/dev.nix"
      echo '${bootstrapjs}' > '$out/src/bootstrap.js'
    else
      sed -e 's/<project-id>/${projectId}/' ${.idx/dev.nix} > "$out/.idx/dev.nix"
    fi
    # Remove the template files themselves and any connection to the template's
    # Git repository
    rm -rf "$out/.git" "$out/idx-template".{nix,json} "$out/node_modules"
  '';
}