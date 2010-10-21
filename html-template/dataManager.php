<?php
  /**
  * Autor: Fernando Tapia Rico
  * Version: 1.0
  * Date: 30/09/2010
  *
  * This file process the RDF sources.
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
  $sources = explode('-s-e-p-a-r-a-t-o-r-', urldecode($_GET['sources']));
  $mainClass = urldecode($_GET['class']);
  $output = '';
  $properties = array();
  $properties = explode('-s-e-p-a-r-a-t-o-r-', urldecode($_GET['properties']));
  foreach ($sources as $url) {
    $content = file_get_contents($url);
    if ($content) {
      $content = remove_ns($content);
      $content = utf8_encode($content);
      $xml = simplexml_load_string($content);
      foreach ($xml->{$mainClass} as $node) {
        $output .= '    <rdfbrowser_class_item>' . "\n";
        $output .= '      <rdfbrowser_source>' . $url. '</rdfbrowser_source>' . "\n";
        $result = class_toxml($node, $output, $properties);
        $output = $result[0];
        $properties = $result[1];
        $output .= '    </rdfbrowser_class_item>' . "\n";
      }
      foreach ($xml->{'Description'} as $node) {
        $type = $node->{'type'};
        if (strstr($type['resource'], $mainClass)) {
          $output .= '    <rdfbrowser_class_item>' . "\n";
          $output .= '      <rdfbrowser_source>' . $url. '</rdfbrowser_source>' . "\n";
          $result = class_toxml($node, $output, $properties);
          $output = $result[0];
          $properties = $result[1];
          $output .= '    </rdfbrowser_class_item>' . "\n";
        }
      }
    }
    else {
      print('<?xml version="1.0" encoding="UTF-8"?>' . "\n");
      print('<root>' . "\n");
      print('  <result>Error loading source: ' . $url . '</result>' . "\n");
      print('</root>' . "\n");
      exit();
    }
  }
  print('<?xml version="1.0" encoding="UTF-8"?>' . "\n");
  print('<root>' . "\n");
  print('  <result>OK</result>' . "\n");
  print('  <rdfbrowser_items>' . "\n");
  print($output);
  print('  </rdfbrowser_items>' . "\n");
  print('  <rdfbrowser_properties>' . implode('-s-e-p-a-r-a-t-o-r-', $properties) . '</rdfbrowser_properties>' . "\n");
  print('</root>' . "\n");
  exit();
  
  /**
  * This function removes the namespaces found on the RDF file.
  */
  function remove_ns($content) {
    $a = explode('<rdf:RDF', $content);
    $b = explode('>',$a[1]);
    $xmlns = explode('xmlns:',$b[0]);
    foreach ($xmlns as $xml_ns) {
      $values = explode('=',$xml_ns);
      $prefix = trim($values[0]);
      if ($prefix) $content = str_replace($prefix . ':', '', $content);
    }
    $content = str_replace('&lt;', '', str_replace('&gt;', '', $content));
    return $content;
  }
  
  /**
  * This function extracts the properties and values from the element.
  */
  function class_toxml($node, $output, $properties) {
    foreach ($node->children() as $property) {
      $children = $property->children();
      if (count($children) > 0) {
        $result = class_toxml($property, $output, $properties);
        $output = $result[0];
        $properties = $result[1];
      }
      else {
        if ($property->getName() != 'type') {
          $value = $property['resource'];
          if (!$value) {
            $value = $property;
          }
          $output .= '      <' . $property->getName() . '>' . $value. '</' . $property->getName() . '>' . "\n";
          if (!in_array($property->getName(), $properties)) {
            $properties[] = $property->getName();
          }
        }
      }
    }
    return array($output, $properties);
  }

  function errorHandler( $errno, $errstr, $errfile, $errline, $errcontext) {
    print('<?xml version="1.0" encoding="UTF-8"?>' . "\n");
    print('<root>' . "\n");
    print('  <result>');
    print('Error: ' . print_r( $errstr, true) . ' . File ' . print_r( $errfile, true) . ' on line ' . print_r( $errline, true));
    print('</result>' . "\n");
    print('</root>' . "\n");
    exit();
  }

?>