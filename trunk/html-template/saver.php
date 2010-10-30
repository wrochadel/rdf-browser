<?php

  /**
  * Autor: Fernando Tapia Rico
  * Version: 1.1
  * Date: 30/10/2010
  *
  * It saves the administrator settings into the 'settings' XML file
  *
  * Copyright (C) 2010  Fernando Tapia Rico
  * 
  * This program is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation, either version 3 of the License, or
  * any later version.
  * 
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  * 
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */

  set_error_handler('errorHandler');
  $params = explode('-s-e-p-a-r-a-t-o-r-', urldecode($_GET['params']));
  $result = FALSE;
  if (count($params) == 7) {
    $file = 'settings';
    $output  = '<root>';
    $output .= '<mainclass>' . urldecode($_GET['class']) . '</mainclass>';
    $output .= '<source>' . urldecode($_GET['sources']) . '</source>';
    $output .= '<radius><field>' . $params[0] . '</field><count>' . $params[1] . '</count></radius>';
    $output .= '<fill><field>' . $params[2] . '</field><count>' . $params[3] . '</count></fill>';
    $output .= '<alpha><field>' . $params[4] . '</field><count>' . $params[5] . '</count></alpha>';
    $output .= '<color>' . $params[6] . '</color>';
    $output .= '<username>' . urldecode($_GET['username']) . '</username><password>' . urldecode($_GET['password']) . '</password>';
    $output .= '</root>';
    $result = file_put_contents($file, $output);
  }
  print('<?xml version="1.0" encoding="UTF-8"?>' . "\n");
  print('<root>' . "\n");
  if (!$result) {
    print('  <message>Error saving settings. Try again</message>' . "\n");
  }
  else {
    print('  <message>Settings saved successfully</message>' . "\n");
  }
  print('</root>');
  exit();

  function errorHandler( $errno, $errstr, $errfile, $errline, $errcontext) {
    print('<?xml version="1.0" encoding="UTF-8"?>' . "\n");
    print('<root>' . "\n");
    print('  <message>');
    print('Error: ' . print_r( $errstr, true) . ' . File ' . print_r( $errfile, true) . ' on line ' . print_r( $errline, true));
    print('</message>' . "\n");
    print('</root>');
    exit();
  }
?>