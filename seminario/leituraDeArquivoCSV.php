<?php
  $dados = file('arquivo.csv');
  foreach ($dados as $linha) {
    $campos = explode(',', $linha);
    echo "Nome: " . $campos[0] . ", Email: " . $campos[1] . "<br>";
  }
?>
