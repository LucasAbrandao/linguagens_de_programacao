<?php
  $email = "usuario@dominio.com";
  if (filter_var($email, FILTER_VALIDATE_EMAIL)) {
    echo "Email válido.";
  } else {
    echo "Email inválido.";
  }
?>
