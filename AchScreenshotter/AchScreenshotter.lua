-----------------------------------------------------------
-- DO NOT MODIFY!!!
-- NOT MY CODE. Got it here: http://www.wowwiki.com/Wait on July 5th, 2009
-----------------------------------------------------------
local waitTable = {};
local waitFrame = nil;

function AchScreens__wait(delay, func, ...)
  if(type(delay)~="number" or type(func)~="function") then
    return false;
  end
  if(waitFrame == nil) then
    waitFrame = CreateFrame("Frame","WaitFrame", UIParent);
    waitFrame:SetScript("onUpdate",function (self,elapse)
      local count = #waitTable;
      local i = 1;
      while(i<=count) do
        local waitRecord = tremove(waitTable,i);
        local d = tremove(waitRecord,1);
        local f = tremove(waitRecord,1);
        local p = tremove(waitRecord,1);
        if(d>elapse) then
          tinsert(waitTable,i,{d-elapse,f,p});
          i = i + 1;
        else
          count = count - 1;
          f(unpack(p));
        end
      end
    end);
  end
  tinsert(waitTable,{delay,func,{...}});
  return true;
end
-------------------------------------------------------------
-- END OF DO NOT MODIFY!!
-------------------------------------------------------------

local AS_MOD_NAME = "Achievement Screenshotter";
local AS_MOD_VERSION = "3.1.1";

function AchScreens_OnLoad( )

	this:RegisterEvent( "ACHIEVEMENT_EARNED" );
	print( AS_MOD_NAME, AS_MOD_VERSION, ": Loaded" );

end

function AchScreens_OnEvent( self, event, ... )

	AchScreens__wait(2, Screenshot, ... )
	--Screenshot();

end