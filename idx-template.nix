{ pkgs, projectId, bootstrapJs, ... }:
{
  bootstrap = ''
    cp -rf ${./.} "$out/"
    chmod -R +w "$out"
    echo 'bootstrapJs was set to: ${bootstrapJs}'
    # Apply project ID to configs
    if [ !-z '${bootstrapJs}' ]
    then
      sed -e 's/<project-id>/${projectId}/' ${.idx/dev.nix} | sed -e 's/terraform init/# skip/' | sed -e 's/terraform apply/# skip/' > "$out/.idx/dev.nix"
      echo '${bootstrapJs}' > '$out/src/bootstrap.js'
    else
      sed -e 's/<project-id>/${projectId}/' ${.idx/dev.nix} > "$out/.idx/dev.nix"
    fi
    # Remove the template files themselves and any connection to the template's
    # Git repository
    rm -rf "$out/.git" "$out/idx-template".{nix,json} "$out/node_modules"
  '';
}