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
local AS_MOD_VERSION = "3.0.3";
local AS_DEBUG = false;

--local AS_testing = false;

function AchScreens_OnLoad( )
	if( AS_DEBUG ) then
		print( "AchScreens_OnLoad()... ");
	end
	
	this:RegisterEvent( "ADDON_LOADED");		-- for retrieving the saved variables
	this:RegisterEvent( "ACHIEVEMENT_EARNED" ); -- for achievement screenshots
	this:RegisterEvent( "PLAYER_LEVEL_UP" );    -- for leveling up screenshots
	this:RegisterEvent( "CHAT_MSG_SYSTEM" );    -- for reputation milestone screenshots

	--this:RegisterEvent( "UNIT_SPELLCAST_SUCCEEDED" ); -- for testing only
end

function AchScreens_OnEvent( self, event, ... )
	if( AS_DEBUG ) then
		print( "AchScreens_OnEvent() ... event = ", event );
	end

	if( event == "ADDON_LOADED" ) then
		if( select(1,...) == "AchScreenshotter" ) then
			print( AS_MOD_NAME .. " v." .. AS_MOD_VERSION .. " has loaded." );
			if( AS_ss_achs == nil ) then
				AS_ss_achs = true;
				AS_ss_levels = true;
				AS_ss_reps = true;
			end
			-- must be seperate because old users will have saved settings already
			if( AS_hideui == nil ) then
				AS_hideui = false;
			end
		end
	elseif( event == "ACHIEVEMENT_EARNED" and AS_ss_achs ) then
		AchScreens__wait( 2, Screenshot, ... );
    elseif( event == "PLAYER_LEVEL_UP" and AS_ss_levels ) then
		AS_take_screenshot(1);
	elseif( event == "CHAT_MSG_SYSTEM" and AS_ss_reps ) then
		if( string.find(select(1,...), "You are now")
		and string.find(select(1,...), "with") ) then
			AS_take_screenshot(1);
		end
	-- elseif( event == "UNIT_SPELLCAST_SUCCEEDED" ) then -- for debugging only
		-- print( "SPELLCAST SUCCEEDED" );
		-- AS_take_screenshot(2);
	end
end

function AS_take_screenshot(delay)
	if( AS_hideui ) then
		AchScreens__wait( delay, AS_myHide );
		AchScreens__wait( delay, Screenshot );
		-- UIParent:Show(); -- Doesn't work. I suspect it is related to the delay
		-- funciton I'm using. Until I find a work around, the user will have to
		-- press Esc after the screenshot is taken.
	else
		AchScreens__wait( delay, Screenshot );
	end
end

function AS_myShow()
	UIParent:Show();
end

function AS_myHide()
	UIParent:Hide();
end

-----------------------------------------------------------
-- Slash Command Code
-----------------------------------------------------------
SLASH_SCREENSHOTTER1, SLASH_SCREENSHOTTER2 = '/as', '/screenshotter';
SlashCmdList["SCREENSHOTTER"] = handler;
function SlashCmdList.SCREENSHOTTER( msg, editbox )
	if( AS_DEBUG ) then
		print( "AS_slash_handler()..." );
	end
	
	-- if( msg == "test" ) then
		-- if( AS_testing ) then
			-- this:UnregisterEvent( "UNIT_SPELLCAST_SUCCEEDED" );
			-- AS_testing = false;
			-- print( "Screenshots will not be taken on spell casts." );
		-- else
			-- this:RegisterEvent( "UNIT_SPELLCAST_SUCCEEDED" ); 
			-- AS_testing = true;
			-- print( "Screenshots will be taken on spell casts." );
		-- end
	-- else
		AS_Open_Options();
	-- end
end
----------------------------------------------------------
-- END OF SLASH COMMAND CODE
-----------------------------------------------------------
function AS_Open_Options()
	if( AS_DEBUG ) then
		print( "AS_Open_Options()..." );
	end

	AS_fs_title:SetText( AS_MOD_NAME .. " v." .. AS_MOD_VERSION );
	AS_check_Achs:SetChecked(AS_ss_achs);
	AS_check_Levels:SetChecked(AS_ss_levels);
	AS_check_Reps:SetChecked(AS_ss_reps);
	AS_check_hideUI:SetChecked(AS_hideui);
	
	AS_Options_Frame:Show();
end

function AS_Close_Options()
	if( AS_DEBUG ) then
		print( "AS_Close_Options()... " );
	end
	
	AS_Options_Frame:Hide();
	
	AS_ss_achs = AS_check_Achs:GetChecked();
	AS_ss_levels = AS_check_Levels:GetChecked();
	AS_ss_reps = AS_check_Reps:GetChecked();
	AS_hideui = AS_check_hideUI:GetChecked();
	
	if( AS_hideui ) then
		print( "Achievement Screenshotter: press Esc to show the UI after the screenshot is taken." );
	end
end