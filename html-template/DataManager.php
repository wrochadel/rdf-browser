<?php
  /**
  * Autor: Fernando Tapia Rico
  * Version: 1.2
  * Date: 30/10/2010
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

  include_once("arc/ARC2.php");

  set_error_handler('errorHandler');
  $sources = explode('-s-e-p-a-r-a-t-o-r-', urldecode($_GET['sources']));
  $mainClass = urldecode($_GET['class']);
  $output = '';
  $properties = array();
  $properties = explode('-s-e-p-a-r-a-t-o-r-', urldecode($_GET['properties']));
  foreach ($sources as $url) {
    $content = file_get_contents($url);
    if ($content) {
      $xml = getXML($content);
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
      if ($prefix) {
        $content = str_replace('<' . $prefix, '-r-d-f-b-r-o-w-s-e-r-t-a-g-' . $prefix, $content);
        $content = str_replace('</' . $prefix, '-r-d-f-b-r-o-w-s-e-r-t-a-g-/' . $prefix, $content);
        $content = str_replace($prefix . ':', '', $content);
      }
    }
    $content = str_replace('&lt;', '<', str_replace('&gt;', '>', $content));
    $content = str_replace('-r-d-f-b-r-o-w-s-e-r-t-a-g-', '<', strip_tags($content));
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
  
  /**
  * This function returns a XML with the content.
  */
  function getXML($content) {
    // Check format. Available formats RDF and RDFa
    if (stristr($content,'<html') != FALSE) {
      $rdfxml = 'error';
      $config = array('auto_extract' => 0);
      $parser = ARC2::getRDFParser();
      $parser->parse('', $content);
      $parser->extractRDF('rdfa');
      $rdfxml = $parser->toRDFXML($parser->getTriples());
      if ($rdfxml == 'error') {
        print('<?xml version="1.0" encoding="UTF-8"?>' . "\n");
        print('<root>' . "\n");
        print('  <result>Error extracting RDF from the HTML (RDfa)</result>' . "\n");
        print('</root>' . "\n");
        exit();
      }
      else {
        $content = $rdfxml;
      }
    }
    elseif (stristr($content,'<rdf:RDF') == FALSE) {
      print('<?xml version="1.0" encoding="UTF-8"?>' . "\n");
      print('<root>' . "\n");
      print('  <result>Format error, not RDF or HTML/RDFa data found</result>' . "\n");
      print('</root>' . "\n");
      exit();
    }
    $content = remove_ns($content);
    $content = utf8_encode($content);
    return simplexml_load_string($content);
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