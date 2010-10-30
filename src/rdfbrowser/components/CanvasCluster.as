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
  import mx.controls.Label;

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
    public var drawQueue:Array = null;
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
    public function CanvasCluster(data:Array, maxRadius:Number, maxFill:Number, maxAlpha:Number) {
      process(data, maxRadius, maxFill, maxAlpha);
    }
    
    /**
     * This function creates the galaxy. It process
     * all the data and draw the elements.
     * 
     * @param data Array of CanvasItem elements to draw.
     */
    public function process(data:Array, maxRadius:Number, maxFill:Number, maxAlpha:Number):void {
      drawQueue = new Array();
      for (var x:int = 0; x < data.length; x++) {
        (CanvasItem)(data[x]).setRadius(maxRadius);
        (CanvasItem)(data[x]).setFill(maxFill);
        (CanvasItem)(data[x]).setAlpha(maxAlpha);
        addCircle(data[x]);
      }
    }
    
    /**
     * This function places the CanvasItem element. It sets
     * the x and y coordinates of the element and 
     * introduces it into the "drawn" array.
     * 
     * @param element CanvasItem element to draw.
     */
     public function addCircle (element:CanvasItem):void {
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
      element.draw();
      this.addChild(element);
      drawQueue.push(element);
    }
    
    /**
     * This functions checks if the CanvasItem element doesn't have points in 
     * common with other element of the galaxy 
     * 
     * @param element CanvasItem element to check
     * @return true: the element has points in common with other element (collision).<br/>
     *         false: the element has not points in common with other element.
     */
    public function checkCollision(element:CanvasItem):Boolean {
      for (var x:int = 0; x < drawQueue.length; x++) {
        // Check collision: distance between centers is lower than the sum of the radii.
        if (Math.sqrt(Math.pow(drawQueue[x].x - element.x + drawQueue[x].radius - element.radius,2) + Math.pow(drawQueue[x].y - element.y + drawQueue[x].radius - element.radius,2)) <= (drawQueue[x].radius + element.radius)) {
          return true;
          break;
        }
      }
      return false;
    }
  }
}