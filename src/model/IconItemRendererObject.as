package model
{
	import mx.collections.ArrayList;

	public class IconItemRendererObject extends Object
	{
		public var label : String;
		public var icon : String;		// url to the icon of the Drag Thumb, only way I could figure out how to get an icon associated was using the iconField
		
		public function IconItemRendererObject(label:String)
		{
			super();
			this.label = label;
			this.icon = "icons/DragThumb.png";
		}
		
		static public function initArrayList(labelArray:Array) {
			var objectArray :Array = new Array();
			for each (var label : String in labelArray) {
				objectArray.push(new IconItemRendererObject(label));
			}
			return new ArrayList(objectArray);
		}
	}
}