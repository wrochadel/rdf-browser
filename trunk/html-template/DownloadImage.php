<?php

  /**
  * Autor: Fernando Tapia Rico
  * Version: 1.2
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

  header('Content-disposition: attachment; filename=export.png');
  header("Content-type: application/png");

  readfile('php://input');
?>