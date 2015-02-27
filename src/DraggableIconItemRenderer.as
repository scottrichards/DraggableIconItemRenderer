package
{
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    
    import mx.core.InteractionMode;
    
    import spark.components.IconItemRenderer;
    import spark.components.List;
    import spark.skins.spark.ScrollerSkin;
    
    /**
    * A subclass of IconItemRenderer that allows the decorator object to
    * be dragged and dropped within the List or into other Lists.
    */
    public class DraggableIconItemRenderer extends IconItemRenderer
    {
        /** The Scroller skin to use when in mouse interaction mode */
        public var dragModeScrollerSkin:* = NoScrollBarScrollerSkin;

        /** 
        * These properties allow you to define some extra hit area beyond
        * the bounds of the decorator object.  This is handy if you have a
        * small decorator and want to make it easier to grab with a finger.
        * 
        * Be careful that your excess padding on the top and bottom aren't 
        * large enough to overlap other renderers.
        */
        public var extraDragThumbHitPaddingLeft:Number = 0;
        public var extraDragThumbHitPaddingTop:Number = 0;
        public var extraDragThumbHitPaddingRight:Number = 0;
        public var extraDragThumbHitPaddingBottom:Number = 0;
        
        /** A lightweight class that can handle mouse events */
        private var dragRegion:Sprite;
        
        /** The skin that the Scroller had before being changed to the drag mode scroller skin */
        private var initialScrollerSkin:*;
        
        /**
        * Create a dragRegion when the decorator gets created.
        */
        override protected function createDecoratorDisplay():void
        {
            super.createDecoratorDisplay();
            
            if (!dragRegion)
            {
                dragRegion = new Sprite();
                dragRegion.addEventListener(MouseEvent.MOUSE_DOWN, handleDragRegionMouseDown);
                addChild(dragRegion);
            }
        }

        /**
        * Destroy the drag region when the decorator gets destroyed. 
        */
        override protected function destroyDecoratorDisplay():void
        {
            super.destroyDecoratorDisplay();
            
            if (dragRegion)
            {
                dragRegion.removeEventListener(MouseEvent.MOUSE_DOWN, handleDragRegionMouseDown);
                removeChild(dragRegion);
                dragRegion = null;
            }
        }
        
        /**
        * When a user mouses down on the dragRegion we change this List into mouse
        * interactionMode so that normal desktop drag-and-drop functionality is enabled.
        * 
        * In this mode the size of the scrollbars are calculated slightly differently 
        * so we set the Scroller to have a skin that doesn't show any scrollbars.
        */
        private function handleDragRegionMouseDown(event:MouseEvent):void
        {
            var parentList:List = owner as List;
            
            // temporarily change to mouse interaction mode
            parentList.setStyle('interactionMode', InteractionMode.MOUSE);
            
            // when in that mode use a Scroller skin that has no scrollbars
            initialScrollerSkin = parentList.scroller.getStyle('skinClass');
            parentList.scroller.setStyle('skinClass', dragModeScrollerSkin);
            
            // add a listener to go back to touch interaction mode when the user mouses up
            systemManager.addEventListener(MouseEvent.MOUSE_UP, restoreTouchMode);
        }
        
        /**
        * Handles going back into touch interaction mode.
        */
        private function restoreTouchMode(event:MouseEvent):void
        {
            var parentList:List = owner as List;
            
            // go back into touch interaction mode
            parentList.setStyle('interactionMode', InteractionMode.TOUCH);
            
            // set the Scroller skin back to what it was
            // use call later to avoid a funny flicker
            callLater(function():void {
                parentList.scroller.setStyle('skinClass', initialScrollerSkin)}
            );
        }
        
        /**
        * Draw some invisible pixels into the dragRegion after the decorator has been
        * sized and positioned. 
        */
        override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.layoutContents(unscaledWidth, unscaledHeight);

            if (dragRegion)
            {
                // consider some extra padding to allow for drag regions slightly larger than the decorator
                var dragRegionWidth:Number = decoratorDisplay.getLayoutBoundsWidth() + 
                                             extraDragThumbHitPaddingLeft + extraDragThumbHitPaddingRight;
                
                var dragRegionHeight:Number = decoratorDisplay.getLayoutBoundsHeight() + 
                                             extraDragThumbHitPaddingTop + extraDragThumbHitPaddingBottom;
                
                // draw an invisible mouse event shield on top of the decoratorDisplay
                dragRegion.graphics.clear();
                dragRegion.graphics.beginFill(0x00FF00, 0);
                dragRegion.graphics.drawRect(decoratorDisplay.getLayoutBoundsX() - extraDragThumbHitPaddingLeft, 
                                             decoratorDisplay.getLayoutBoundsY() - extraDragThumbHitPaddingTop, 
                                             dragRegionWidth, 
                                             dragRegionHeight);
                dragRegion.graphics.endFill();
            }
        }
        
    }
}