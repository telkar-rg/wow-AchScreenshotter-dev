﻿----------------------------------------------------------
-- Option Panel Code
-----------------------------------------------------------
function AS_config_options( panel )
	panel.name = "Ach Screenshotter";
	panel.okay = function (self) AS_Close_Options(); end;
	-- panel.cancel = function (self) AS_Close_Options(); end;
	panel.default = function (self) AS_Default_Options(); end;
	InterfaceOptions_AddCategory(panel);
end

function AS_Open_Options()
	if( AS_DEBUG ) then
		print( "AS_Open_Options()..." );
	end

	AS_fs_title:SetText( AS_MOD_NAME .. " |cFF80FFFFv." .. AS_MOD_VERSION .."|r");
	
	AS_check_hideUI:SetChecked(AS_settings.AS_hideui);
	AS_check_SoundFx:SetChecked(AS_settings.AS_ss_sound);
	
	AS_check_Achs:SetChecked(AS_settings.AS_ss_achs);
	AS_check_Levels:SetChecked(AS_settings.AS_ss_levels);
	AS_check_Reps:SetChecked(AS_settings.AS_ss_reps);
	AS_check_bgs:SetChecked(AS_settings.AS_ss_bgs);
	AS_check_bgs_wins_only:SetChecked(AS_settings.AS_ss_bgs_wins_only);
	--AS_check_arenas:SetChecked(AS_settings.AS_ss_arenas);
	--AS_check_arenas_wins_only:SetChecked(AS_settings.AS_ss_arenas_wins_only);
	AS_check_ShardsOfIllusion:SetChecked(AS_settings.AS_ss_soi_general);
	AS_check_ShardsOfIllusion_sub_raid:SetChecked(AS_settings.AS_ss_soi_raid);
	AS_check_ShardsOfIllusion_sub_LFG:SetChecked(AS_settings.AS_ss_soi_lfg);
	AS_check_ShardsOfIllusion_sub_arena:SetChecked(AS_settings.AS_ss_soi_arena);
	
	AS_auto_check_ChangedButtons();
end

function AS_Default_Options()
	if( AS_DEBUG ) then
		print( "AS_Defualt_Options()..." );
	end
	
	for k, v in pairs(AS_DEFAULT_SETTINGS) do
		AS_settings[k] = v;
	end
end

function AS_Close_Options()
	if( AS_DEBUG ) then
		print( "AS_Close_Options()... " );
	end
	
	AS_settings.AS_hideui = AS_check_hideUI:GetChecked();
	AS_settings.AS_ss_sound = AS_check_SoundFx:GetChecked();
	
	AS_settings.AS_ss_achs = AS_check_Achs:GetChecked();
	AS_settings.AS_ss_levels = AS_check_Levels:GetChecked();
	AS_settings.AS_ss_reps = AS_check_Reps:GetChecked();
	AS_settings.AS_ss_bgs = AS_check_bgs:GetChecked();
	AS_settings.AS_ss_bgs_wins_only = AS_check_bgs_wins_only:GetChecked();
	-- AS_settings.AS_ss_arenas = AS_check_arenas:GetChecked();
	-- AS_settings.AS_ss_arenas_wins_only = AS_check_arenas_wins_only:GetChecked();
	
	AS_settings.AS_ss_soi_general = AS_check_ShardsOfIllusion:GetChecked()
	AS_settings.AS_ss_soi_raid = AS_check_ShardsOfIllusion_sub_raid:GetChecked();
	AS_settings.AS_ss_soi_lfg = AS_check_ShardsOfIllusion_sub_LFG:GetChecked();
	AS_settings.AS_ss_soi_arena = AS_check_ShardsOfIllusion_sub_arena:GetChecked();
	
	if( AS_settngs.AS_hideui ) then
		print( "Achievement Screenshotter: press Esc to show the UI after the screenshot is taken." );
	end
end

function AS_auto_check_arenas()
	if( AS_check_arenas_wins_only:GetChecked() and not AS_check_arenas:GetChecked() ) then
		AS_check_arenas:SetChecked(true);
	end
end

function AS_auto_check_bgs()
	if( AS_check_bgs_wins_only:GetChecked() and not AS_check_bgs:GetChecked() ) then
		AS_check_bgs:SetChecked(true);
	end
end

function AS_auto_uncheck_arena_wins_only()
	if( AS_check_arenas_wins_only:GetChecked() and not AS_check_arenas:GetChecked() ) then
		AS_check_arenas_wins_only:SetChecked(false);
	end
end

function AS_auto_uncheck_bg_wins_only()
	if( AS_check_bgs_wins_only:GetChecked() and not AS_check_bgs:GetChecked() ) then
		AS_check_bgs_wins_only:SetChecked(false);
	end
end

-- Telkar edit here
function AS_auto_uncheck_shard_suboptions()

	if( AS_DEBUG ) then
		print( "AS_auto_uncheck_shard_suboptions()..." );
	end
	
	if AS_check_ShardsOfIllusion:GetChecked() then
		if not AS_check_ShardsOfIllusion_sub_raid:GetChecked() then
			AS_check_ShardsOfIllusion_sub_raid:SetChecked(true);
		end
		if not AS_check_ShardsOfIllusion_sub_LFG:GetChecked() then
			AS_check_ShardsOfIllusion_sub_LFG:SetChecked(true);
		end
		if not AS_check_ShardsOfIllusion_sub_arena:GetChecked() then
			AS_check_ShardsOfIllusion_sub_arena:SetChecked(true);
		end
	else
		if AS_check_ShardsOfIllusion_sub_raid:GetChecked() then
			AS_check_ShardsOfIllusion_sub_raid:SetChecked(false);
		end
		if AS_check_ShardsOfIllusion_sub_LFG:GetChecked() then
			AS_check_ShardsOfIllusion_sub_LFG:SetChecked(false);
		end
		if AS_check_ShardsOfIllusion_sub_arena:GetChecked() then
			AS_check_ShardsOfIllusion_sub_arena:SetChecked(false);
		end
	end
end

function AS_auto_check_shard_Cleanup()
	local cnt = 0
	local cntMax = 3
	if AS_check_ShardsOfIllusion_sub_raid:GetChecked() then cnt = cnt+1 end
	if AS_check_ShardsOfIllusion_sub_LFG:GetChecked() then cnt = cnt+1 end
	if AS_check_ShardsOfIllusion_sub_arena:GetChecked() then cnt = cnt+1 end
	
	if cnt == 0 and AS_check_ShardsOfIllusion:GetChecked() then
		AS_check_ShardsOfIllusion:SetChecked(false)
	elseif cnt > 0 and not AS_check_ShardsOfIllusion:GetChecked() then
		AS_check_ShardsOfIllusion:SetChecked(true)
	end
end


function AS_auto_check_ChangedButtons()
	local isChanged = false
	
	if (AS_check_hideUI:GetChecked() and 1 or 0) ~= (AS_settings.AS_hideui and 1 or 0) then
		AS_fs_hideUI:SetTextColor(0.5,1.0,1.0,1.0)
		isChanged = true
	else
		AS_fs_hideUI:SetTextColor(1.0,1.0,1.0,1.0)
	end
	
	if (AS_check_SoundFx:GetChecked() and 1 or 0) ~= (AS_settings.AS_ss_sound and 1 or 0) then
		AS_fs_SoundFx:SetTextColor(0.5,1.0,1.0,1.0)
		isChanged = true
	else
		AS_fs_SoundFx:SetTextColor(1.0,1.0,1.0,1.0)
	end
	
	if (AS_check_Achs:GetChecked() and 1 or 0) ~= (AS_settings.AS_ss_achs and 1 or 0) then
		AS_fs_Achs:SetTextColor(0.5,1.0,1.0,1.0)
		isChanged = true
	else
		AS_fs_Achs:SetTextColor(1.0,1.0,1.0,1.0)
	end
	
	if (AS_check_Levels:GetChecked() and 1 or 0) ~= (AS_settings.AS_ss_levels and 1 or 0) then
		AS_fs_Levels:SetTextColor(0.5,1.0,1.0,1.0)
		isChanged = true
	else
		AS_fs_Levels:SetTextColor(1.0,1.0,1.0,1.0)
	end
	
	if (AS_check_Reps:GetChecked() and 1 or 0) ~= (AS_settings.AS_ss_reps and 1 or 0) then
		AS_fs_Reps:SetTextColor(0.5,1.0,1.0,1.0)
		isChanged = true
	else
		AS_fs_Reps:SetTextColor(1.0,1.0,1.0,1.0)
	end
	
	if (AS_check_bgs:GetChecked() and 1 or 0) ~= (AS_settings.AS_ss_bgs and 1 or 0) then
		AS_fs_bgs:SetTextColor(0.5,1.0,1.0,1.0)
		isChanged = true
	else
		AS_fs_bgs:SetTextColor(1.0,1.0,1.0,1.0)
	end
	
	if (AS_check_bgs_wins_only:GetChecked() and 1 or 0) ~= (AS_settings.AS_ss_bgs_wins_only and 1 or 0) then
		AS_fs_bgs_wins_only:SetTextColor(0.5,1.0,1.0,1.0)
		isChanged = true
	else
		AS_fs_bgs_wins_only:SetTextColor(1.0,1.0,1.0,1.0)
	end
	
	if (AS_check_ShardsOfIllusion:GetChecked() and 1 or 0) ~= (AS_settings.AS_ss_soi_general and 1 or 0) then
		AS_fs_ShardsOfIllusion:SetTextColor(0.5,1.0,1.0,1.0)
		isChanged = true
	else
		AS_fs_ShardsOfIllusion:SetTextColor(1.0,1.0,1.0,1.0)
	end
	
	if (AS_check_ShardsOfIllusion_sub_raid:GetChecked() and 1 or 0) ~= (AS_settings.AS_ss_soi_raid and 1 or 0) then
		AS_fs_ShardsOfIllusion_sub_raid:SetTextColor(0.5,1.0,1.0,1.0)
		isChanged = true
	else
		AS_fs_ShardsOfIllusion_sub_raid:SetTextColor(1.0,1.0,1.0,1.0)
	end
	
	if (AS_check_ShardsOfIllusion_sub_LFG:GetChecked() and 1 or 0) ~= (AS_settings.AS_ss_soi_lfg and 1 or 0) then
		AS_fs_ShardsOfIllusion_sub_LFG:SetTextColor(0.5,1.0,1.0,1.0)
		isChanged = true
	else
		AS_fs_ShardsOfIllusion_sub_LFG:SetTextColor(1.0,1.0,1.0,1.0)
	end
	
	if (AS_check_ShardsOfIllusion_sub_arena:GetChecked() and 1 or 0) ~= (AS_settings.AS_ss_soi_arena and 1 or 0) then
		AS_fs_ShardsOfIllusion_sub_arena:SetTextColor(0.5,1.0,1.0,1.0)
		isChanged = true
	else
		AS_fs_ShardsOfIllusion_sub_arena:SetTextColor(1.0,1.0,1.0,1.0)
	end
	
	if isChanged then
		AS_option_fs_myName:SetTextColor(0.5,1.0,1.0,1.0)
		AS_option_fs_myName:SetText("Click 'Okay' to save changes")
	else
		AS_option_fs_myName:SetTextColor(1.0,0.82,0.0,1.0)
		AS_option_fs_myName:SetText("by Blamdarot, Telkar-RG")
	end
end
