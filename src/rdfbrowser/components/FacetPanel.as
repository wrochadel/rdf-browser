/*
 * RDF Browser
 * File: FacetPanel.as
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

  import flash.events.Event;
  import flash.events.MouseEvent;
  import mx.containers.Canvas;
  import mx.containers.Panel;
  import mx.controls.Button;
  import mx.controls.Label;
  import mx.controls.List;
  import mx.controls.TextInput;
  import mx.core.Application;
  
  /**
   * This class creates a facet which is used to filter the information.
   * Facet panels are attached to a property and they might be numerical 
   * (number of tags with the selected property or visualization parameters) 
   * or textual values.
   */
  public class FacetPanel extends Panel {

    /**
     * Property attached to the facet.
     */
    public var facet:String;
    /**
     * TRUE: numerical values; FALSE: textual values.
     * 
     * @default false
     */
    public var count:Boolean = false;
    /**
     * TRUE: the property is visualization paramater.
     * 
     * @default false
     */
    public var isParameter:Boolean = false;
    /**
     * List of items in case of literal values.
     * 
     * @default null 
     */
    public var list:List = null;
    /**
     * Minimum value limit in case of numeric values.
     * 
     * @default null 
     */
    public var facetInputLT:TextInput = null;
    /**
     * Maximum value limit in case of numeric values.
     * 
     * @default null 
     */
    public var facetInputGT:TextInput = null;
    /**
     * Close button. Removes the facet from the view.
     */
    private var closeButton:Button;
    /**
     * Parent application.
     */
    private var ParentApp:* = Application.application;
    
    /**
     * FacetPanel class constructor.
     * 
     * @param facet Property attached to the facet.
     * @param count TRUE: numerical values; FALSE: textual values.
     * @param isParameter TRUE: the property is visualization paramater.
     */
    public function FacetPanel(facet: String, count:Boolean, isParameter:Boolean) {
      super();
      this.width = 280;
      this.facet = facet;
      this.count = count;
      this.title =  facet;
      this.isParameter = isParameter;
      // Checki if the property is defined by numerical or textual values.
      if (count || isParameter) {
        // Numerical values.
        var facetCanvas:Canvas = new Canvas() ;
        var label:Label = new Label();
        var applyButton:Button = new Button();
        // Container properties.
        facetCanvas.width = 276;
        facetCanvas.height = 20;
        // "< # <" label properties.
        label.text = "< # <";
        label.x = 50;
        label.y = 0;
        label.width = 50;
        label.setStyle("textAlign", "center");
        // Texfield properties (min. and max. boundaries).
        facetInputLT = new TextInput();
        facetInputLT.width = 50;
        facetInputGT = new TextInput();
        facetInputGT.width = 50;
        facetInputGT.x = 100;
        facetInputGT.y = 0;
        // "Apply" button properties.
        applyButton.label = "Apply";
        applyButton.width = 126;
        applyButton.x = 150;
        applyButton.y = 0;
        applyButton.addEventListener(MouseEvent.CLICK, displayData);
        facetCanvas.addChild(facetInputLT);
        facetCanvas.addChild(facetInputGT);
        facetCanvas.addChild(label);
        facetCanvas.addChild(applyButton);
        this.addChild(facetCanvas);
      }
      else {
        // Textual values.
        // List properties.
        list = new List();
        list.width = 276;
        list.height = 100;
        list.dataProvider = new Array();
        this.addChild(list);
      }
      // Facet panel actions.
      closeButton = new Button();
      closeButton.addEventListener("click", removeFacet);
      if (!count && !isParameter) {
        list.addEventListener(MouseEvent.CLICK, displayData);
      }
    }
    
    override protected function createChildren() : void {
      super.createChildren();
      // Add close button "x". This button removes the panel.
      closeButton.label = "x";
      closeButton.width = 30;
      closeButton.height = 20;
      closeButton.x =  240;
      closeButton.y = 5;
      titleBar.addChild(closeButton);
    }
    
    /**
     * This function (event handler) removes the facet panel from the
     * current view.
     * 
     * @param event Event.
     */
    public function removeFacet(event:Event):void {
      ParentApp.removeFacet(this);
    }
    
    /**
     * This function (event handler) requests to the parent application 
     * a visualization update.
     * 
     * @param event Event.
     */
    public function displayData(event:Event):void {
      ParentApp.displayData();
    }
  }
}