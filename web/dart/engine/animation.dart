part of coUclient;

class Animation
{
	String backgroundImage, animationName, animationStyleString;
	int width, height;
	
	Animation(this.backgroundImage,this.animationName);
	
	Future<Animation> load()
	{
		Completer c = new Completer();
		
		//need to get the avatar background image size dynamically
		//because we cannot guarentee that every glitchen has the same dimensions
		//additionally each animation sprite has different dimensions even for the same glitchen
		ImageElement temp = new ImageElement(src: backgroundImage);
		temp.onLoad.listen((_)
		{
			int width = temp.width;
			int height = temp.height;
			
			//if unknown what animation to play, use the 15th frame of the walk cycle
			if(animationName == 'stillframe')
			{
				this.width = width~/15;
				this.height = height;
				
				//there are 12 frames in the walk cycle, the last 3 in the base.png image are not part of it
				int endPos = width - (width~/15);
				CssStyleSheet styleSheet = document.styleSheets[0] as CssStyleSheet;
				String stillframe = '@-webkit-keyframes stillframe { from { background-position: '+endPos.toString()+'px;} to { background-position: -'+endPos.toString()+'px;}}';
				
				try
				{
					styleSheet.insertRule(stillframe,1); //inserting at 0 throws an error, 1 seems fine
				}
				catch(error){}
				
				stillframe = '@keyframes stillframe { from { background-position: '+endPos.toString()+'px;} to { background-position: -'+endPos.toString()+'px;}}';
				try
				{
					styleSheet.insertRule(stillframe,1); //inserting at 0 throws an error, 1 seems fine
				}
				catch(error){}
				
				animationStyleString = 'stillframe .8s steps(1)';
			}
			
			//if walk-cycle
			if(animationName == 'base')
			{
				this.width = width~/15;
				this.height = height;
				
				//there are 12 frames in the walk cycle, the last 3 in the base.png image are not part of it
				int endPos = width - (width~/15)*3;
				CssStyleSheet styleSheet = document.styleSheets[0] as CssStyleSheet;
				String base = '@-webkit-keyframes base { from { background-position: 0px;} to { background-position: -'+endPos.toString()+'px;}}';								 
				try
				{
					styleSheet.insertRule(base,1); //inserting at 0 throws an error, 1 seems fine
				}
				catch(error){}
				
				base = '@keyframes base { from { background-position: 0px;} to { background-position: -'+endPos.toString()+'px;}}';
				try
				{
					styleSheet.insertRule(base,1); //inserting at 0 throws an error, 1 seems fine
				}
				catch(error){}
				
				animationStyleString = 'base .8s steps(12) infinite';
			}
			
			//if idle animation
			if(animationName == 'idle')
			{
				this.width = width~/29;
				this.height = height~/2;
				
				//there are 57 total frames split over 2 rows (29 and 28)
				//because the idle animation sheet is broken over 2 rows,
				//we need to run two animatinos back to back
			
				CssStyleSheet styleSheet = document.styleSheets[0] as CssStyleSheet;
				String idle = '@-webkit-keyframes idle { from { background-position: 0px 0px;} to { background-position: -'+width.toString()+'px 0px;}}';
				try
				{
					styleSheet.insertRule(idle,1); //inserting at 0 throws an error, 1 seems fine
				}
				catch(error){}
				
				idle = '@keyframes idle { from { background-position: 0px 0px;} to { background-position: -'+width.toString()+'px 0px;}}';
				try
				{
					styleSheet.insertRule(idle,1); //inserting at 0 throws an error, 1 seems fine
				}
				catch(error){}
				
				int halfHeight = height~/2;
				int widthMinus1 = width - (width~/29);
				idle = '@-webkit-keyframes idle2 { from { background-position: 0px '+(-halfHeight).toString()+'px;} to { background-position: '+widthMinus1.toString()+'px '+(-halfHeight).toString()+'px;}}';
				try
				{
					styleSheet.insertRule(idle,1); //inserting at 0 throws an error, 1 seems fine
				}
				catch(error){}
				
				idle = '@keyframes idle2 { from { background-position: 0px '+(-halfHeight).toString()+'px;} to { background-position: '+widthMinus1.toString()+'px '+(-halfHeight).toString()+'px;}}';
				try
				{
					styleSheet.insertRule(idle,1); //inserting at 0 throws an error, 1 seems fine
				}
				catch(error){}
				
				animationStyleString = 'idle 1s 10s steps(29), idle2 1s 11s steps(28)';
			}
			
			//if jump animation
			if(animationName == 'jump')
			{
				this.width = width~/33;
				this.height = height;
				
				//there are 33 frames for the jump animation
				
				CssStyleSheet styleSheet = document.styleSheets[0] as CssStyleSheet;
				String jump = '@-webkit-keyframes jump { from { background-position: 0px;} to { background-position: -'+width.toString()+'px;}}';
				try
				{
					styleSheet.insertRule(jump,1); //inserting at 0 throws an error, 1 seems fine
				}
				catch(error){}
				
				jump =' @keyframes jump { from { background-position: 0px;} to { background-position: -'+width.toString()+'px;}}';
				try
				{
					styleSheet.insertRule(jump,1); //inserting at 0 throws an error, 1 seems fine
				}
				catch(error){}
				
				animationStyleString = 'jump 1s steps(33) infinite';
			}
			
			c.complete(this);
		});
		
		return c.future;
	}
}