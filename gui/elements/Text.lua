-- 
-- Gui - Element - TEXT 
-- 
-- @Interface: --
-- @Author: LS-Modcompany / kevink98
-- @Date: 19.05.2018
-- @Version: 1.0.0.0
-- 
-- @Support: LS-Modcompany
-- 
local debugIndex = g_company.debug:registerScriptName("GlobalCompany-Gui-Text");

GC_Gui_text = {};
local GC_Gui_text_mt = Class(GC_Gui_text, GC_Gui_element);
-- getfenv(0)["GC_Gui_text"] = GC_Gui_text;
g_company.gui.textElement = GC_Gui_text;

function GC_Gui_text:new(gui, custom_mt)
    if custom_mt == nil then
        custom_mt = GC_Gui_text_mt;
    end;
	
	local self = GC_Gui_element:new(gui, custom_mt);
	self.name = "text";
	
	self.textColor = {1,1,1,1};
	self.textColor_disabled = {1,1,1,1};
	self.textColor_selected = {1,1,1,1};
	
	self.textBold = false;
	self.textBold_disabled = false;
	self.textBold_selected = false;
	
	self.textUpperCase = false;
	self.textUpperCase_disabled = false;
	self.textUpperCase_selected = false;
	
	self.textSize = 0.025;
	self.textLineHeightScale = 1.1;
	self.textMaxWidth = nil;
	self.textWrapWidth = 1;
	self.textMaxNumLines = 1;

	self.autoSize = false;
	
	self.textAlignment = RenderText.ALIGN_LEFT;
	self.text = "";	
	
	return self;
end;

function GC_Gui_text:loadTemplate(templateName, xmlFile, key)
	GC_Gui_text:superClass().loadTemplate(self, templateName, xmlFile, key);
	
	
	self.textColor = g_company.gui:getTemplateValueColor(templateName, "textColor", self.textColor);
	self.textColor_disabled = g_company.gui:getTemplateValueColor(templateName, "textColor_disabled", self.textColor_disabled);
	self.textColor_selected = g_company.gui:getTemplateValueColor(templateName, "textColor_selected", self.textColor_selected);
	
	self.textBold = g_company.gui:getTemplateValueBool(templateName, "textBold", self.textBold);
	self.textBold_disabled = g_company.gui:getTemplateValueBool(templateName, "textBold_disabled", self.textBold_disabled);
	self.textBold_selected = g_company.gui:getTemplateValueBool(templateName, "textBold_selected", self.textBold_selected);
	
	self.textUpperCase = g_company.gui:getTemplateValueBool(templateName, "textUpperCase", self.textUpperCase);
	self.textUpperCase_disabled = g_company.gui:getTemplateValueBool(templateName, "textUpperCase_disabled", self.textUpperCase_disabled);
	self.textUpperCase_selected = g_company.gui:getTemplateValueBool(templateName, "textUpperCase_selected", self.textUpperCase_selected);
	
	self.autoSize = g_company.gui:getTemplateValueBool(templateName, "autoSize", self.autoSize);
	
	self.textSize = unpack(GuiUtils.getNormalizedValues(g_company.gui:getTemplateValue(templateName, "textSize"), {self.outputSize[2]}, {self.textSize}));
	self.textMaxWidth = unpack(GuiUtils.getNormalizedValues(g_company.gui:getTemplateValue(templateName, "textMaxWidth"), {self.outputSize[1]}, {self.textMaxWidth}));
	self.textWrapWidth = unpack(GuiUtils.getNormalizedValues(g_company.gui:getTemplateValue(templateName, "textWrapWidth"), {self.outputSize[1]}, {self.textWrapWidth}));
	self.textMaxNumLines = g_company.gui:getTemplateValueNumber(templateName, "textMaxNumLines", self.textMaxNumLines);
	self.textLineHeightScale = g_company.gui:getTemplateValueNumber(templateName, "textLineHeightScale", self.textLineHeightScale);
	self.margin = GuiUtils.getNormalizedValues(g_company.gui:getTemplateValue(templateName, "textMargin"), self.outputSize, self.margin);

	local textAlignment = g_company.gui:getTemplateValue(templateName, "textAlignment");
	if textAlignment ~= nil then
		textAlignment = textAlignment:lower();
		if textAlignment == "left" then
			self.textAlignment = RenderText.ALIGN_LEFT;
		elseif textAlignment == "center" then
			self.textAlignment = RenderText.ALIGN_CENTER;
		elseif textAlignment == "right" then
			self.textAlignment = RenderText.ALIGN_RIGHT;
		end;
	end;
	
	local text = ""
	if xmlFile ~= nil then
	 	text = getXMLString(xmlFile, string.format("%s#text", key));	
	end
	if text ~= nil then 
		if text:sub(-1) == ":" then
			text = text:sub(1, text:len() - 1);
			self:setText(g_company.languageManager:getText(text, ":", text), true);
		else
			self:setText(g_company.languageManager:getText(text, nil, text), true);
		end;
    end;
	self:loadOnCreate();
end;

function GC_Gui_text:copy(src)
	GC_Gui_text:superClass().copy(self, src);
	
	self.textColor = src.textColor;
	self.textColor_disabled = src.textColor_disabled;
	self.textColor_selected = src.textColor_selected;
	
	self.textBold = src.textBold;
	self.textBold_disabled = src.textBold_disabled;
	self.textBold_selected = src.textBold_selected;
	
	self.textUpperCase = src.textUpperCase;
	self.textUpperCase_disabled = src.textUpperCase_disabled;
	self.textUpperCase_selected = src.textUpperCase_selected;
	
	self.textSize = src.textSize;
	self.textMaxWidth = src.textMaxWidth;
	self.textWrapWidth = src.textWrapWidth;
	self.textMaxNumLines = src.textMaxNumLines;

	self.autoSize = src.autoSize;
	
	self.textAlignment = src.textAlignment;
	self:setText(src.text, true);
	self:copyOnCreate();
end;

function GC_Gui_text:delete()
	GC_Gui_text:superClass().delete(self);

end;

function GC_Gui_text:mouseEvent(posX, posY, isDown, isUp, button, eventUsed)
	GC_Gui_text:superClass().mouseEvent(self, posX, posY, isDown, isUp, button, eventUsed);
end;

function GC_Gui_text:keyEvent(unicode, sym, modifier, isDown, eventUsed)
	GC_Gui_text:superClass().keyEvent(self, unicode, sym, modifier, isDown, eventUsed);

end;

function GC_Gui_text:update(dt)
	GC_Gui_text:superClass().update(self, dt);

end;

function GC_Gui_text:draw(index)
	self.drawPosition[1], self.drawPosition[2] = g_company.gui:calcDrawPos(self, index);

	if self.text ~= nil and self.text ~= "" then
		
		setTextAlignment(self.textAlignment);
		setTextWrapWidth(self.textWrapWidth);
		setTextLineHeightScale(self.textLineHeightScale);
		
		local text = self.text;
		if self.textUpperCase then
			text = utf8ToUpper(text);
		end;
		
		setTextBold(self:getTextBold());
		local r,g,b,a = unpack(self:getTextColor());
		setTextColor(r,g,b,a);		
		
		if self.textMaxWidth ~= nil then
			text = Utils.limitTextToWidth(text, self.textSize, self.textMaxWidth, false, "...");
		end;

		if self.autoSize then
			self.size[1] = self:getTextWidth();
			self.drawPosition[1], self.drawPosition[2] = g_company.gui:calcDrawPos(self, index);
		end;
		
		
		local x,y = self.drawPosition[1], self.drawPosition[2];
		
		if self.textAlignment == RenderText.ALIGN_CENTER then
			x = x + self.size[1] / 2;
		elseif self.textAlignment == RenderText.ALIGN_RIGHT then
			x = x + self.size[1];
		end;
				
		renderText(x,y, self.textSize, text);
		
		setTextBold(false);
		setTextAlignment(RenderText.ALIGN_LEFT);
		setTextLineHeightScale(RenderText.DEFAULT_LINE_HEIGHT_SCALE);
		setTextColor(1, 1, 1, 1);
		setTextWrapWidth(0);
		
		if self.debugEnabled then
			setOverlayColor(GuiElement.debugOverlay, 0, 1, 0, 1)
				local yPixel = 1 / g_screenHeight;
			if self.textMaxWidth ~= nil then
				renderOverlay(GuiElement.debugOverlay, self.drawPosition[1], self.drawPosition[2], self.textMaxWidth, yPixel);
			else
				renderOverlay(GuiElement.debugOverlay, self.drawPosition[1], self.drawPosition[2], self.size[1], yPixel);
			end
		end
		
	end;
	GC_Gui_text:superClass().draw(self);
end;

function GC_Gui_text:setTextSize(size)
    self.textSize = size;
	self.size[2] = self.textSize;
end;

function GC_Gui_text:setText(text, forceTextSize)
	text = tostring(text);
	if self.textUpperCase then
        text = utf8ToUpper(text);
    end;
	local leftover = nil;
    if self.textMaxNumLines ~= nil and self.textWrapWidth ~= nil then
        setTextWrapWidth(self.textWrapWidth);
        local l = getTextLength(self.textSize, text, self.textMaxNumLines);
        setTextWrapWidth(0);
        leftover = utf8Substr(text, l);
        text = utf8Substr(text, 0, l);
    end;

    self.text = text;

    if (self.size[1] == 0 and self.size[2] == 0) or forceTextSize then
        local width = self:getTextWidth();
        if self.textWrapWidth > 0 then
            width = math.min(width, self.textWrapWidth)
        end
		if self.size[1] ~= 0 then
			self.size = {self.size[1], self.textSize};
		else
			self.size = {width, self.textSize};
		end;
    end

    return leftover;
end;

function GC_Gui_text:setTextColor(r,g,b,a)
    self.textColor = {r,g,b,a};
end;

function GC_Gui_text:setTextColorSelected(r,g,b,a)
    self.textColor_selected = {r,g,b,a};
end;

function GC_Gui_text:getTextWidth(text)
	if text == nil then
		text = self.text;
	end;
    setTextBold(self.textBold);
    local width = getTextWidth(self.textSize, self.text);
    setTextBold(false);
    return width;
end;

function GC_Gui_text:getTextHeight()
    setTextWrapWidth(self.textWrapWidth);
    setTextBold(self.textBold);
    setTextLineHeightScale(self.textLineHeightScale);
    local height, numLines = getTextHeight(self.textSize, self.text);
    setTextLineHeightScale(RenderText.DEFAULT_LINE_HEIGHT_SCALE);
    setTextBold(false);
    setTextWrapWidth(0);
    return height, numLines;
end

function GC_Gui_text:getTextColor()
    if self:getDisabled() then
        return self.textColor_disabled;
    elseif self:getIsSelected() then
        return self.textColor_selected;
    else
        return self.textColor;
    end;
end;

function GC_Gui_text:getTextBold()
    if self:getDisabled() then
        return self.textBold_disabled;
    elseif self:getIsSelected() then
        return self.textBold_selected;
    else
        return self.textBold;
    end;
end;

function GC_Gui_text:onOpen()
	if self.callback_onOpen ~= nil then
		self.gui[self.callback_onOpen](self.gui, self, self.parameter);
	end;
	GC_Gui_text:superClass().onOpen(self);
end;
















