/*
 * RDF Browser
 * File: CanvasItem.as
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

  import flash.filters.DropShadowFilter;
  
  import mx.containers.Canvas;
  
  /**
   * This class creates a canvas object which represents an item of
   * the galaxy. The shape of the item is a circle and its customization
   * parameters are:
   * <ul>
   * <li> <b>radius.</b> The radius of the circle. </li>
   * <li> <b>fill.</b> The radius of the inner circle (expressed in percentage respect the radius of the circle). </li>
   * <li> <b>alpha.</b> Transparency of the circle (expressed in percentage). </li>
   * <li> <b>color.</b> Color of the circle. </li>
   * </ul>
   */
  public class CanvasItem extends Canvas {

    /**
     * Short description of the item.
     */
    public var title:String;
    /**
     * Value of the property associated to the radius visualization parameter.
     */
    public var radius:Number;
    /**
     * Value of the property associated to the alpha visualization parameter.
     */
    public var transparency:Number;
    /**
     * Value of the property associated to the fill visualization parameter.
     */
    public var fill:Number;
    /**
     * Value of the property associated to the color visualization parameter.
     */
    private var colorNormal:uint, colorHighlighted:uint;
    private var normalColors:Array = new Array(0x11B5C1, 0xFBCB00, 0xD10D24, 0x09BD33, 0xD40DCD, 0xA14E06, 0x048A2E, 0x5B3199, 0xAD0942, 0xAAAAAA);
    private var highlightedColors:Array = new Array(0x2F7082, 0xC5850B, 0xA1081A, 0x04781F, 0x9E0699, 0xDB6B09, 0x04D446, 0x8C53E0, 0xF70A5D, 0xDDDDDD);


    /**
     * CanvasItem class constructor.
     * 
     * @param radius Value of the property associated to the radius visualization parameter.
     * @param fill Value of the property associated to the fill visualization parameter.
     * @param transparency Value of the property associated to the alpha visualization parameter.
     * @param colorNormal Color of the outer circle of the item.
     * @param colorHighlighted Color of the inner circle of the item.
     * @param title Shor description of the item.
     */
    public function CanvasItem(radius:Number, fill:Number, transparency:Number, color:int, title:String) {
      super();
      this.radius = radius;
      this.fill = fill;
      this.transparency = transparency;
      this.title = title;
      this.colorNormal = normalColors[color%10];
      this.colorHighlighted = highlightedColors[color%10];
    }
    
    /**
     * This function sets the radius of the item.
     * 
     * @param maxRadius Maximum value of the property associated to the radius parameter.
     */
    public function setRadius(maxRadius:Number):void {
      if (maxRadius > 0) {
        radius = 8 + 40*(radius/maxRadius);
      }
    }
    
    /**
     * This function sets the fill of the item (expressed in percentage respect the radius of the circle).
     * 
     * @param maxFill Maximum value of the property associated to the fill parameter.
     */
    public function setFill(maxFill:Number):void {
      if (maxFill > 0) {
        fill = fill/maxFill;
      }
    }
    
    /**
     * This function sets the alpha of the item (expressed in percentage).
     * 
     * @param maxTransparency Maximum value of the property associated to the alpha parameter.
     */
    public function setAlpha (maxTransparency:Number):void {
      if (maxTransparency > 0) {
          transparency = 0.2 + 0.8*(transparency/maxTransparency);
      } 
      else {
        transparency = 1; 
      }
    }
    
    /**
     * This function sets the position of the item.
     * 
     * @param xPosition Coordinate x.
     * @param yPosition Coordinate y.
     */
    public function setXY(xPosition:Number, yPosition:Number):void {
      this.x = xPosition - radius;
      this.y = yPosition - radius;
    }
    
    /**
     * This function draws the item.
     */
    public function draw():void {
      this.graphics.clear();
      this.width = radius*2;
      this.height = radius*2;
      this.graphics.beginFill(colorNormal);
      // Draw the outer circle (radius parameter).
      this.graphics.drawCircle(this.width/2,this.height/2,radius*(9/10));
      this.graphics.beginFill(colorHighlighted);
      // Draw the inner circle (fill parameter).
      this.graphics.drawCircle(this.width/2,this.height/2,radius*(9/10)*(fill));
      this.graphics.endFill();
      this.toolTip = title;
      // Transparency of the item (alpha parameter)
      this.alpha = transparency;
      // Shadow effect on the item.
      var shadow:DropShadowFilter = new DropShadowFilter();
      shadow.distance = 0;
      shadow.angle = 90;
      shadow.quality = 20;
      shadow.strength = 0.8;
      shadow.inner = false;
      shadow.color = colorNormal;
      this.filters = [shadow];
    }
  }
}