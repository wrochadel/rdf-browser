/*
 * RDF Browser
 * File: CanvasCluster.as
 * Author: Fernando Tapia Rico
 * Version: 1.0
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
package rdfbrowser.components {

  import mx.containers.Canvas;
  import mx.controls.Alert;

  /**
   * This class creates a canvas object which creates and contains 
   * the galaxy. The galaxy is created following the process:
   * <ul>
   * <li> <b>1.</b> A random angle θ is defined. The center of the 
   * CanvasItem expressed on polar coordinates is: center = (r, θ) r ∈ [0, ∞)</li>
   * <li> <b>2.</b> The function checks if the element doesn't have points in 
   * common with other element of the galaxy (checkCollisions function). In case of 
   * collision, the radius r is increased until the element can be placed.</li>
   * <li> <b>3.</b> The CanvasItem element is drawn. </li>
   * </ul>
   */
  public class CanvasCluster extends Canvas {
    
    /**
     * Array of the elements to draw.
     * 
     * @default null
     */
    private var drawQueue:Array = null;
    /**
     * Minimum coordinate x of all the elements drawn.
     * 
     * @default 0
     */
    private var minimumWidth:Number = 0;
    /**
     * Maximum coordinate x of all the elements drawn.
     * 
     * @default 0
     */
    private var maximumWidth:Number = 0;
    /**
     * Minimum coordinate y of all the elements drawn.
     * 
     * @default 0
     */
    private var minimumHeight:Number = 0;
    /**
     * Maximum coordinate y of all the elements drawn.
     * 
     * @default 0
     */
    private var maximumHeight:Number = 0;
    /**
     * Counter to control the number of iterations.
     * It avoids infinite loops.
     * 
     * @default 0
     */
    private var counter:Number = 0;
    
    /**
     * CanvasCluster class constructor.
     * 
     * @param data Array of CanvasItem elements to draw.
     */
    public function CanvasCluster(data:Array) {
      process(data);
    }
    
    /**
     * This function creates the galaxy. It process
     * all the data and draw the elements.
     * 
     * @param data Array of CanvasItem elements to draw.
     */
    public function process(data:Array):void {
      drawQueue = new Array();
      minimumWidth = 0;
      maximumWidth = 0;
      maximumHeight = 0;
      minimumHeight = 0;
      for (var x:int = 0; x < data.length; x++) {
        addCircle(data[x]);
      }
      if (((maximumWidth - minimumWidth)  > 650 || (maximumHeight - minimumHeight)  > 650 ) && counter < 5) {
        // If the width of the representation is higher than 650px the process has to be repeated.
        counter++;
        this.process(data);
      }
      else {
        this.height = (maximumHeight - minimumHeight) + 100;
        this.width = (maximumWidth - minimumWidth) + 100;
        for (var y:int = 0; y < drawQueue.length; y++) {
          drawQueue[y].setXY(drawQueue[y].x - minimumWidth + 25, drawQueue[y].y - minimumHeight + 25);
          drawQueue[y].draw();
          this.addChild(drawQueue[y]);
        }
      }
    }
    
    /**
     * This function places the CanvasItem element. It sets
     * the x and y coordinates of the element and 
     * introduces it into the "drawn" array.
     * 
     * @param element CanvasItem element to draw.
     */
    private function addCircle (element:CanvasItem):void {
      if (drawQueue.length == 0) {
        // The first element is placed on the center.
        element.setXY(0,0);
      }
      else {
        var radius:Number = 0;
        var randomAngle:Number  = Math.round(Math.random()*360);
        var sinAngle:Number = Math.sin(randomAngle * Math.PI/180);
        var cosAngle:Number = Math.cos(randomAngle * Math.PI/180);
        element.setXY(sinAngle * radius, cosAngle * radius);
        while (checkCollision(element)) {
          radius ++;
          element.setXY(sinAngle * radius, cosAngle * radius);
        }
      }
      drawQueue.push(element);
      if ((element.x - element.radius) < minimumWidth) minimumWidth = element.x - element.radius;
      if ((element.x + element.radius) > maximumWidth) maximumWidth = element.x + element.radius;
      if ((element.y - element.radius) < minimumHeight) minimumHeight = element.y - element.radius;
      if ((element.y + element.radius) > maximumHeight) maximumHeight = element.y + element.radius;
    }
    
    /**
     * This functions checks if the CanvasItem element doesn't have points in 
     * common with other element of the galaxy 
     * 
     * @param element CanvasItem element to check
     * @return true: the element has points in common with other element (collision).<br/>
     *         false: the element has not points in common with other element.
     */
    private function checkCollision(element:CanvasItem):Boolean {
      for (var x:int = 0; x < drawQueue.length; x++) {
        // Check collision: distance between centers is lower than the sum of the radii.
        if (Math.sqrt(Math.pow(drawQueue[x].x - element.x,2) + Math.pow(drawQueue[x].y - element.y,2)) <= (drawQueue[x].radius + element.radius)) {
          return true;
          break;
        }
      }
      return false;
    }
  }
}