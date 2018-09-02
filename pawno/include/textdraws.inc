new Text:TDEditor_TD[11];
new Text:TDEditor_Speed[10];
new Text: skin[3];  //// Для скинов

LoadingTextDraws()
{

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
														
														// APED //
														
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	TDEditor_TD[0] = TextDrawCreate(545.999633, 128.275588, "box");
	TextDrawLetterSize(TDEditor_TD[0], 0.000000, 31.640050);
	TextDrawTextSize(TDEditor_TD[0], 0.000000, 171.000000);
	TextDrawAlignment(TDEditor_TD[0], 2);
	TextDrawColor(TDEditor_TD[0], -1);
	TextDrawUseBox(TDEditor_TD[0], 1);
	TextDrawBoxColor(TDEditor_TD[0], 145);
	TextDrawSetShadow(TDEditor_TD[0], 0);
	TextDrawSetOutline(TDEditor_TD[0], 0);
	TextDrawBackgroundColor(TDEditor_TD[0], 255);
	TextDrawFont(TDEditor_TD[0], 1);
	TextDrawSetProportional(TDEditor_TD[0], 1);
	TextDrawSetShadow(TDEditor_TD[0], 0);

	TDEditor_TD[1] = TextDrawCreate(545.999633, 133.253356, "box");
	TextDrawLetterSize(TDEditor_TD[1], 0.000000, 27.760019);
	TextDrawTextSize(TDEditor_TD[1], 0.000000, 162.000000);
	TextDrawAlignment(TDEditor_TD[1], 2);
	TextDrawColor(TDEditor_TD[1], 16777215);
	TextDrawUseBox(TDEditor_TD[1], 1);
	TextDrawBoxColor(TDEditor_TD[1], 16777070);
	TextDrawSetShadow(TDEditor_TD[1], 0);
	TextDrawSetOutline(TDEditor_TD[1], 0);
	TextDrawBackgroundColor(TDEditor_TD[1], 255);
	TextDrawFont(TDEditor_TD[1], 3);
	TextDrawSetProportional(TDEditor_TD[1], 1);
	TextDrawSetShadow(TDEditor_TD[1], 0);

	TDEditor_TD[2] = TextDrawCreate(525.400451, 396.421997, "");
	TextDrawLetterSize(TDEditor_TD[2], 0.000000, 0.000000);
	TextDrawTextSize(TDEditor_TD[2], 50.000000, 19.000000);
	TextDrawAlignment(TDEditor_TD[2], 1);
	TextDrawColor(TDEditor_TD[2], -2);
	TextDrawSetShadow(TDEditor_TD[2], 0);
	TextDrawSetOutline(TDEditor_TD[2], 0);
	TextDrawBackgroundColor(TDEditor_TD[2], -1061109739);
	TextDrawFont(TDEditor_TD[2], 5);
	TextDrawSetProportional(TDEditor_TD[2], 0);
	TextDrawSetShadow(TDEditor_TD[2], 0);
	TextDrawSetSelectable(TDEditor_TD[2], true);
	TextDrawSetPreviewModel(TDEditor_TD[2], 1318);
	TextDrawSetPreviewRot(TDEditor_TD[2], 0.000000, 0.000000, 90.000000, 1.000000);

	TDEditor_TD[3] = TextDrawCreate(545.999938, 133.253372, "box");
	TextDrawLetterSize(TDEditor_TD[3], 0.000000, 2.200031);
	TextDrawTextSize(TDEditor_TD[3], 0.000000, 162.000000);
	TextDrawAlignment(TDEditor_TD[3], 2);
	TextDrawColor(TDEditor_TD[3], -1);
	TextDrawUseBox(TDEditor_TD[3], 1);
	TextDrawBoxColor(TDEditor_TD[3], 255);
	TextDrawSetShadow(TDEditor_TD[3], 0);
	TextDrawSetOutline(TDEditor_TD[3], 0);
	TextDrawBackgroundColor(TDEditor_TD[3], 255);
	TextDrawFont(TDEditor_TD[3], 3);
	TextDrawSetProportional(TDEditor_TD[3], 1);
	TextDrawSetShadow(TDEditor_TD[3], 0);

	TDEditor_TD[4] = TextDrawCreate(608.399047, 132.257934, "23:04");
	TextDrawLetterSize(TDEditor_TD[4], 0.400000, 1.600000);
	TextDrawAlignment(TDEditor_TD[4], 2);
	TextDrawColor(TDEditor_TD[4], 16777215);
	TextDrawSetShadow(TDEditor_TD[4], 0);
	TextDrawSetOutline(TDEditor_TD[4], 0);
	TextDrawBackgroundColor(TDEditor_TD[4], 255);
	TextDrawFont(TDEditor_TD[4], 3);
	TextDrawSetProportional(TDEditor_TD[4], 1);
	TextDrawSetShadow(TDEditor_TD[4], 0);

	TDEditor_TD[5] = TextDrawCreate(482.799346, 132.257949, "100%");
	TextDrawLetterSize(TDEditor_TD[5], 0.400000, 1.600000);
	TextDrawAlignment(TDEditor_TD[5], 2);
	TextDrawColor(TDEditor_TD[5], 16777215);
	TextDrawSetShadow(TDEditor_TD[5], 0);
	TextDrawSetOutline(TDEditor_TD[5], 0);
	TextDrawBackgroundColor(TDEditor_TD[5], 255);
	TextDrawFont(TDEditor_TD[5], 3);
	TextDrawSetProportional(TDEditor_TD[5], 1);
	TextDrawSetShadow(TDEditor_TD[5], 0);

	TDEditor_TD[6] = TextDrawCreate(555.400390, 159.977844, "");
	TextDrawLetterSize(TDEditor_TD[6], 0.000000, 0.000000);
	TextDrawTextSize(TDEditor_TD[6], 71.000000, 66.000000);
	TextDrawAlignment(TDEditor_TD[6], 1);
	TextDrawColor(TDEditor_TD[6], -2);
	TextDrawSetShadow(TDEditor_TD[6], 0);
	TextDrawSetOutline(TDEditor_TD[6], 0);
	TextDrawBackgroundColor(TDEditor_TD[6], 16777030);
	TextDrawFont(TDEditor_TD[6], 5);
	TextDrawSetProportional(TDEditor_TD[6], 0);
	TextDrawSetShadow(TDEditor_TD[6], 0);
	TextDrawSetSelectable(TDEditor_TD[6], true);
	TextDrawSetPreviewModel(TDEditor_TD[6], 1239);
	TextDrawSetPreviewRot(TDEditor_TD[6], 0.000000, 0.000000, 0.000000, 1.000000);

	TDEditor_TD[7] = TextDrawCreate(466.600433, 160.475601, "");
	TextDrawLetterSize(TDEditor_TD[7], 0.000000, 0.000000);
	TextDrawTextSize(TDEditor_TD[7], 71.000000, 66.000000);
	TextDrawAlignment(TDEditor_TD[7], 1);
	TextDrawColor(TDEditor_TD[7], -2);
	TextDrawSetShadow(TDEditor_TD[7], 0);
	TextDrawSetOutline(TDEditor_TD[7], 0);
	TextDrawBackgroundColor(TDEditor_TD[7], 16777030);
	TextDrawFont(TDEditor_TD[7], 5);
	TextDrawSetProportional(TDEditor_TD[7], 0);
	TextDrawSetShadow(TDEditor_TD[7], 0);
	TextDrawSetSelectable(TDEditor_TD[7], true);
	TextDrawSetPreviewModel(TDEditor_TD[7], 1240);
	TextDrawSetPreviewRot(TDEditor_TD[7], 0.000000, 0.000000, 0.000000, 1.000000);

	TDEditor_TD[8] = TextDrawCreate(466.600433, 230.662109, "");
	TextDrawLetterSize(TDEditor_TD[8], 0.000000, 0.000000);
	TextDrawTextSize(TDEditor_TD[8], 71.000000, 66.000000);
	TextDrawAlignment(TDEditor_TD[8], 1);
	TextDrawColor(TDEditor_TD[8], -2);
	TextDrawSetShadow(TDEditor_TD[8], 0);
	TextDrawSetOutline(TDEditor_TD[8], 0);
	TextDrawBackgroundColor(TDEditor_TD[8], 16777030);
	TextDrawFont(TDEditor_TD[8], 5);
	TextDrawSetProportional(TDEditor_TD[8], 0);
	TextDrawSetShadow(TDEditor_TD[8], 0);
	TextDrawSetSelectable(TDEditor_TD[8], true);
	TextDrawSetPreviewModel(TDEditor_TD[8], 1210);
	TextDrawSetPreviewRot(TDEditor_TD[8], 0.000000, 0.000000, 0.000000, 1.000000);

	TDEditor_TD[9] = TextDrawCreate(555.400878, 230.164352, "");
	TextDrawLetterSize(TDEditor_TD[9], 0.000000, 0.000000);
	TextDrawTextSize(TDEditor_TD[9], 71.000000, 66.000000);
	TextDrawAlignment(TDEditor_TD[9], 1);
	TextDrawColor(TDEditor_TD[9], -2);
	TextDrawSetShadow(TDEditor_TD[9], 0);
	TextDrawSetOutline(TDEditor_TD[9], 0);
	TextDrawBackgroundColor(TDEditor_TD[9], 16777030);
	TextDrawFont(TDEditor_TD[9], 5);
	TextDrawSetProportional(TDEditor_TD[9], 0);
	TextDrawSetShadow(TDEditor_TD[9], 0);
	TextDrawSetSelectable(TDEditor_TD[9], true);
	TextDrawSetPreviewModel(TDEditor_TD[9], 1277);
	TextDrawSetPreviewRot(TDEditor_TD[9], 0.000000, 0.000000, 0.000000, 1.000000);
	
	TDEditor_TD[10] = TextDrawCreate(511.800506, 303.337646, "");
	TextDrawLetterSize(TDEditor_TD[10], 0.000000, 0.000000);
	TextDrawTextSize(TDEditor_TD[10], 71.000000, 66.000000);
	TextDrawAlignment(TDEditor_TD[10], 1);
	TextDrawColor(TDEditor_TD[10], -2);
	TextDrawSetShadow(TDEditor_TD[10], 0);
	TextDrawSetOutline(TDEditor_TD[10], 0);
	TextDrawBackgroundColor(TDEditor_TD[10], 16777030);
	TextDrawFont(TDEditor_TD[10], 5);
	TextDrawSetProportional(TDEditor_TD[10], 0);
	TextDrawSetShadow(TDEditor_TD[10], 0);
	TextDrawSetSelectable(TDEditor_TD[10], true);
	TextDrawSetPreviewModel(TDEditor_TD[10], 1314);
	TextDrawSetPreviewRot(TDEditor_TD[10], 0.000000, 0.000000, 0.000000, 1.000000);
	
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
														
														// SPEEDOMETER //
														
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////														
	TDEditor_Speed[0] = TextDrawCreate(507.200042, 378.653564, "km/h");
	TextDrawLetterSize(TDEditor_Speed[0], 0.200799, 0.962844);
	TextDrawAlignment(TDEditor_Speed[0], 1);
	TextDrawColor(TDEditor_Speed[0], -1);
	TextDrawSetShadow(TDEditor_Speed[0], 0);
	TextDrawSetOutline(TDEditor_Speed[0], 1);
	TextDrawBackgroundColor(TDEditor_Speed[0], 255);
	TextDrawFont(TDEditor_Speed[0], 3);
	TextDrawSetProportional(TDEditor_Speed[0], 1);
	TextDrawSetShadow(TDEditor_Speed[0], 0);

	TDEditor_Speed[1] = TextDrawCreate(567.599609, 356.256835, "box");
	TextDrawLetterSize(TDEditor_Speed[1], 0.000000, 5.920001);
	TextDrawTextSize(TDEditor_Speed[1], 0.000000, 133.000000);
	TextDrawAlignment(TDEditor_Speed[1], 2);
	TextDrawColor(TDEditor_Speed[1], -1);
	TextDrawUseBox(TDEditor_Speed[1], 1);
	TextDrawBoxColor(TDEditor_Speed[1], 121);
	TextDrawSetShadow(TDEditor_Speed[1], 0);
	TextDrawSetOutline(TDEditor_Speed[1], 0);
	TextDrawBackgroundColor(TDEditor_Speed[1], 255);
	TextDrawFont(TDEditor_Speed[1], 1);
	TextDrawSetProportional(TDEditor_Speed[1], 1);
	TextDrawSetShadow(TDEditor_Speed[1], 0);
	
	TDEditor_Speed[2] = TextDrawCreate(539.600036, 401.555664, "box");
	TextDrawLetterSize(TDEditor_Speed[2], 0.000000, 0.599995);
	TextDrawTextSize(TDEditor_Speed[2], 628.000000, 0.000000);
	TextDrawAlignment(TDEditor_Speed[2], 1);
	TextDrawColor(TDEditor_Speed[2], -1);
	TextDrawUseBox(TDEditor_Speed[2], 1);
	TextDrawBoxColor(TDEditor_Speed[2], 255);
	TextDrawSetShadow(TDEditor_Speed[2], 0);
	TextDrawSetOutline(TDEditor_Speed[2], 0);
	TextDrawBackgroundColor(TDEditor_Speed[2], 255);
	TextDrawFont(TDEditor_Speed[2], 1);
	TextDrawSetProportional(TDEditor_Speed[2], 1);
	TextDrawSetShadow(TDEditor_Speed[2], 0);	
	
	TDEditor_Speed[3] = TextDrawCreate(549.000000, 355.497772, "engine");
	TextDrawLetterSize(TDEditor_Speed[3], 0.326797, 1.291376);
	TextDrawAlignment(TDEditor_Speed[3], 1);
	TextDrawColor(TDEditor_Speed[3], -2139062017);
	TextDrawSetShadow(TDEditor_Speed[3], 0);
	TextDrawSetOutline(TDEditor_Speed[3], 1);
	TextDrawBackgroundColor(TDEditor_Speed[3], 255);
	TextDrawFont(TDEditor_Speed[3], 2);
	TextDrawSetProportional(TDEditor_Speed[3], 1);
	TextDrawSetShadow(TDEditor_Speed[3], 0);

	TDEditor_Speed[4] = TextDrawCreate(516.000122, 358.848962, "300");
	TextDrawLetterSize(TDEditor_Speed[4], 0.465599, 2.351644);
	TextDrawAlignment(TDEditor_Speed[4], 2);
	TextDrawColor(TDEditor_Speed[4], -1);
	TextDrawSetShadow(TDEditor_Speed[4], 3);
	TextDrawSetOutline(TDEditor_Speed[4], 0);
	TextDrawBackgroundColor(TDEditor_Speed[4], 255);
	TextDrawFont(TDEditor_Speed[4], 3);
	TextDrawSetProportional(TDEditor_Speed[4], 1);
	TextDrawSetShadow(TDEditor_Speed[4], 3);

	TDEditor_Speed[5] = TextDrawCreate(539.200195, 373.181976, "box");
	TextDrawLetterSize(TDEditor_Speed[5], 0.000000, 0.679996);
	TextDrawTextSize(TDEditor_Speed[5], 627.000000, 0.000000);
	TextDrawAlignment(TDEditor_Speed[5], 1);
	TextDrawColor(TDEditor_Speed[5], -1);
	TextDrawUseBox(TDEditor_Speed[5], 1);
	TextDrawBoxColor(TDEditor_Speed[5], 255);
	TextDrawSetShadow(TDEditor_Speed[5], 0);
	TextDrawSetOutline(TDEditor_Speed[5], 0);
	TextDrawBackgroundColor(TDEditor_Speed[5], 255);
	TextDrawFont(TDEditor_Speed[5], 1);
	TextDrawSetProportional(TDEditor_Speed[5], 1);
	TextDrawSetShadow(TDEditor_Speed[5], 0);

	TDEditor_Speed[6] = TextDrawCreate(518.800415, 399.066680, "100_%");
	TextDrawLetterSize(TDEditor_Speed[6], 0.263199, 1.321244);
	TextDrawAlignment(TDEditor_Speed[6], 2);
	TextDrawColor(TDEditor_Speed[6], -1);
	TextDrawSetShadow(TDEditor_Speed[6], 2);
	TextDrawSetOutline(TDEditor_Speed[6], 0);
	TextDrawBackgroundColor(TDEditor_Speed[6], 255);
	TextDrawFont(TDEditor_Speed[6], 3);
	TextDrawSetProportional(TDEditor_Speed[6], 1);
	TextDrawSetShadow(TDEditor_Speed[6], 2);

	TDEditor_Speed[7] = TextDrawCreate(610.999694, 355.017791, "doors");
	TextDrawLetterSize(TDEditor_Speed[7], 0.322396, 1.331199);
	TextDrawAlignment(TDEditor_Speed[7], 2);
	TextDrawColor(TDEditor_Speed[7], -1040187137);
	TextDrawSetShadow(TDEditor_Speed[7], 0);
	TextDrawSetOutline(TDEditor_Speed[7], 1);
	TextDrawBackgroundColor(TDEditor_Speed[7], 255);
	TextDrawFont(TDEditor_Speed[7], 2);
	TextDrawSetProportional(TDEditor_Speed[7], 1);
	TextDrawSetShadow(TDEditor_Speed[7], 0);
	
	TDEditor_Speed[8] = TextDrawCreate(582.800109, 366.213378, "IIIIIIIIIIIIIIIIIIIIIIIIIIII");
	TextDrawLetterSize(TDEditor_Speed[8], 0.418399, 2.112713);
	TextDrawAlignment(TDEditor_Speed[8], 2);
	TextDrawColor(TDEditor_Speed[8], 610003);
	TextDrawSetShadow(TDEditor_Speed[8], 0);
	TextDrawSetOutline(TDEditor_Speed[8], 0);
	TextDrawBackgroundColor(TDEditor_Speed[8], 255);
	TextDrawFont(TDEditor_Speed[8], 1);
	TextDrawSetProportional(TDEditor_Speed[8], 1);
	TextDrawSetShadow(TDEditor_Speed[8], 0);
	
		
	TDEditor_Speed[9] = TextDrawCreate(538.800170, 397.075561, "I_I_I_I_I_I_I_I_I_I_I_I_I");
	TextDrawLetterSize(TDEditor_Speed[9], 0.400000, 1.600000);
	TextDrawAlignment(TDEditor_Speed[9], 1);
	TextDrawColor(TDEditor_Speed[9], -65281);
	TextDrawSetShadow(TDEditor_Speed[9], 0);
	TextDrawSetOutline(TDEditor_Speed[9], 0);
	TextDrawBackgroundColor(TDEditor_Speed[9], 255);
	TextDrawFont(TDEditor_Speed[9], 1);
	TextDrawSetProportional(TDEditor_Speed[9], 1);
	TextDrawSetShadow(TDEditor_Speed[9], 0);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
														
														//REGSKIN //
														
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	
	skin[0] = TextDrawCreate(250.000000, 300.000000, "LD_BEAT:left"); 
    TextDrawBackgroundColor(skin[0], 255); 
    TextDrawFont(skin[0], 4); 
    TextDrawLetterSize(skin[0], 0.500000, 1.000000); 
    TextDrawColor(skin[0], -1); 
    TextDrawSetOutline(skin[0], 0); 
    TextDrawSetProportional(skin[0], 1); 
    TextDrawSetShadow(skin[0], 1); 
    TextDrawUseBox(skin[0], 1); 
    TextDrawBoxColor(skin[0], 255); 
    TextDrawTextSize(skin[0], 34.000000, 28.000000); 
    TextDrawSetSelectable(skin[0], true);//Данная функция добавлена в 0.3e, true - делает текстдрав кликабельным, false - отключает кликабельность 

    skin[1] = TextDrawCreate(360.000000, 300.000000, "LD_BEAT:right"); 
    TextDrawBackgroundColor(skin[1], 255); 
    TextDrawFont(skin[1], 4); 
    TextDrawLetterSize(skin[1], 0.500000, 1.000000); 
    TextDrawColor(skin[1], -1); 
    TextDrawSetOutline(skin[1], 0); 
    TextDrawSetProportional(skin[1], 1); 
    TextDrawSetShadow(skin[1], 1); 
    TextDrawUseBox(skin[1], 1); 
    TextDrawBoxColor(skin[1], 255); 
    TextDrawTextSize(skin[1], 34.000000, 28.000000); 
    TextDrawSetSelectable(skin[1], true); 

    skin[2] = TextDrawCreate(318.000000, 370.000000, FixText("Выбрать")); 
    TextDrawAlignment(skin[2], 2); 
    TextDrawBackgroundColor(skin[2], 255); 
    TextDrawFont(skin[2], 1); 
    TextDrawLetterSize(skin[2], 0.679999, 1.900000); 
    TextDrawColor(skin[2], -1); 
    TextDrawSetOutline(skin[2], 0); 
    TextDrawSetProportional(skin[2], 1); 
    TextDrawSetShadow(skin[2], 1); 
    TextDrawUseBox(skin[2], 1); 
    TextDrawBoxColor(skin[2], 0); 
    TextDrawTextSize(skin[2], 15.000000, 68.000000); 
    TextDrawSetSelectable(skin[2], true);  
	
	return 1;
}