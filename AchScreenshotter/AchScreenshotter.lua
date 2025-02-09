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

local AS_player_faction_id;
AS_settings = {};

function AchScreens_OnLoad(panel)
	if( AS_DEBUG ) then
		print( "AchScreens_OnLoad()... ");
	end
	
	this:RegisterEvent( "ADDON_LOADED");		-- for retrieving the saved variables
	this:RegisterEvent( "PLAYER_LOGOUT" );		-- for updating the mod version in the saved variables table
	this:RegisterEvent( "ACHIEVEMENT_EARNED" ); -- for achievement screenshots
	this:RegisterEvent( "PLAYER_LEVEL_UP" );    -- for leveling up screenshots
	this:RegisterEvent( "CHAT_MSG_SYSTEM" );    -- for reputation milestone screenshots
	this:RegisterEvent( "UPDATE_BATTLEFIELD_STATUS" ); -- for end of bgs and arenas
	--this:RegisterEvent( "COMBAT_LOG_EVENT_UNFILTERED" ); -- for boss kills
	
	AS_config_options( panel );
end

function AchScreens_OnEvent( self, event, ... )
	if( AS_DEBUG ) then
		print( "AchScreens_OnEvent() ... event = ", event );
	end

	if( event == "ADDON_LOADED" ) then
		AS_addon_loaded( select(1,...) );
	elseif( event == "PLAYER_LOGOUT" ) then
		AS_player_logout();
	elseif( event == "ACHIEVEMENT_EARNED" and AS_settings.AS_ss_achs ) then
		AS_achievement_earned();
    elseif( event == "PLAYER_LEVEL_UP" and AS_settings.AS_ss_levels ) then
		AS_player_level_up();
	elseif( event == "CHAT_MSG_SYSTEM" and AS_settings.AS_ss_reps ) then
		AS_chat_msg_system( select(1,...) );
	elseif( event == "UPDATE_BATTLEFIELD_STATUS" and (AS_settings.AS_ss_bgs or AS_settings.AS_ss_arenas) ) then
		AS_update_battlefield_status();
	--elseif( event == "COMBAT_LOG_EVENT_UNFILTERED" ) then
		--AS_combat_log_event( select(2,...), select(6,...) );
	end
end

function AS_addon_loaded( modName )
	if( modName == AS_MOD_NAME_NO_SPACES ) then
		print( AS_MOD_NAME .. " v." .. AS_MOD_VERSION .. " has loaded." );
		
		for k, v in pairs(AS_DEFAULT_SETTINGS) do
			if not AS_settings[k] then
				AS_settings[k] = v;
			end
		end
		
		if( UnitFactionGroup("player") == "Horde" ) then
			AS_player_faction_id = AS_HORDE_ID;
		else
			AS_player_faction_id = AS_ALLIANCE_ID;
		end
	end
end

function AS_player_logout()
	AS_settings.AS_saved_mod_version = AS_MOD_VERSION;
end

function AS_achievement_earned()
	AS_take_screenshot(1);
end

function AS_player_level_up()
	AS_take_screenshot(1);
end

function AS_chat_msg_system( msg )
	if( string.find( msg, "You are now")
	and string.find( msg, "with") ) then
		AS_take_screenshot(1);
	end
end

function AS_update_battlefield_status()
	local winner = GetBattlefieldWinner();
	if( AS_DEBUG ) then
		print( " winner = ", winner );
		print( " UnitFactionGroup() = ", UnitFactionGroup("player") );
		print( " AS_ss_bgs_wins_only = ", AS_settings.AS_ss_bgs_wins_only );
	end
	
	if( winner ~= nil ) then
		if( IsActiveBattlefieldArena() ) then
			if( AS_settings.AS_ss_arenas and (not AS_settings.AS_ss_arenas_wins_only) ) then
				AS_take_screenshot(1);
			elseif( AS_settings.AS_ss_arenas_wins_only and winner == get_players_team_index() ) then
				AS_take_screenshot(1);
			end
		else -- they are in a battleground
			if( AS_settings.AS_ss_bgs and (not AS_settings.AS_ss_bgs_wins_only) ) then
				AS_take_screenshot(1);
			elseif( AS_settings.AS_ss_bgs_wins_only and winner == AS_player_faction_id ) then
				AS_take_screenshot(1);
			end
		end
	end
end

function get_players_team_index()
	local greenTeamName = GetBattlefieldTeamInfo(0);
	for i = 0, AS_MAX_NUM_ARENA_TEAMS do
		if( greenTeamName == GetArenaTeam(i) ) then
			return 0;
		end
	end
	return 1;
end

-- function AS_combat_log_event( eventType, destGUID )
	-- --print( "combat_log_event" );
	-- if( eventType == "UNIT_DIED" ) then
		-- print( "UNIT_DIED" );
		-- print( "GUID == ", destGUID );
		-- print( "UnitLevel() == ", UnitLevel(destGUID) ); -- returns 0 
		-- print( "UnitClassification() == ", UnitClassification(destGUID) );
		-- print( "UnitCreatureType() == " , UnitCreatureType(destGUID) );-- returns nil
		-- if( UnitLevel(destGUID) == -1 ) then
			-- print( "UnitLevel() == -1" );
		-- elseif( UnitClassification(destGUID) == "worldboss" ) then
			-- AS_take_screenshot(0);
		-- end
	-- end
-- end

function AS_take_screenshot(delay)
	if( AS_settings.AS_hideui ) then
		AchScreens__wait( delay, AS_myHide );
		AchScreens__wait( delay, Screenshot );
		--UIParent:Show(); -- Doesn't work. I suspect it is related to the delay
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

	InterfaceOptionsFrame_OpenToCategory(AS_Options_Panel);
end
-----------------------------------------------------------