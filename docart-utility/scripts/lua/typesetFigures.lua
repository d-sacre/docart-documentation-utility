--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- docART Utility - A Python/Lua(LaTeX) based tool for semi-automated documentation --
-- Source: https://github.com/d-sacre/docart-documentation-utility/                 --
-- Version: alpha-2022-04-30                                                        --
-- License: GNU General Public License (GPLv3)                                      --
-- Copyright (C) 2022 Martin Stimpfl, Daniel Sacré                                  --
--                                                                                  --
-- This program is free software: you can redistribute it and/or modify             --
-- it under the terms of the GNU General Public License as published by             --
-- the Free Software Foundation, either version 3 of the License, or                --
-- (at your option) any later version.                                              --
--                                                                                  --
-- This program is distributed in the hope that it will be useful,                  --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of                   --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                    --
-- GNU General Public License for more details.                                     --
--                                                                                  --
-- You should have received a copy of the GNU General Public License                --
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.           --
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

--+++Complete+++
-- Definition of delimiters and keywords
local groupKey=";"
local elementKey=","

local missingImageKey="missingImage"
local widthKey="width"
local heightKey="height"
local aspectKey="aspect"
local gridKey="grid"
local layoutRowcolsMaxepKey = "x"

-- Definition of LaTeX command string elements
-- for figure environment
local figEnvStart = "\\begin{figure}[htb]\\centering"
local figEnvEnd = "\\end{figure}"

-- for subfigure environment
local subfigEnvStart ="\\begin{subfigure}{"
local subfigEnvWidthEnd = "}\\centering"
local subfigEnvEnd = "\\end{subfigure}"
local subfigHorizontalSpacer = "\\hfill"
local subfigVerticalSpacer = "\\\\[0.25cm]"
local subfigMaxUseableWidthFactor=0.99
local subfigDefaultHorizontalSpacerFactor=0.01
local subfigWidthAndHorizontalSpacerUnit = "\\linewidth"

-- for graphics inclusion
local graphicsStart = "\\includegraphics["
local graphicsWidth = "width="
local graphicsHeight = "height="
local graphicsMiddle = "]{"
local graphicsEnd = "}"


-- split a string into a table
function splitStringIntoTable(stringToSplit, delimiter)
    result = {};
    for match in (stringToSplit .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match);
    end
    return result;
end

-- return true when string contains other string
function stringRegex(stringToSearchIn, stringToFind)
    local matchResult = false

    for match in (stringToSearchIn):gmatch("(.-)" .. stringToFind) do
        matchResult = true
    end

    return matchResult
end

-- determine the type 

 -- First stage of cleaning mandatory user input
function mandatoryUserInputCleaning(inputString)
    local inputRawArray= splitStringIntoTable(inputString, groupKey)-- split the string into table at ";"
    local inputCleanedArray = {}

    for index=1, #inputRawArray-1 do -- len-1 to prevent empty content after last ";"
        local stringToProcess = inputRawArray[index]
        local stringAsArray = {}
        local cleanedArrayStage1 = {}

        if stringToProcess ~= "" then -- do not process empty strings
            stringAsArray = splitStringIntoTable(stringToProcess, elementKey) -- split the string into table at ","
            
            for subindex=1,#stringAsArray do
                if subindex == 1 then -- copy the image object (file path/missingImage/TikZ) directly into clean array                    
                    table.insert(cleanedArrayStage1,stringAsArray[subindex])
                -- else
                --     print("else")
                end
            end

            if #cleanedArrayStage1 ~= 0 then -- if the cleaning array is not empty,
                table.insert(inputCleanedArray,cleanedArrayStage1) -- append it to the precleaned array
            end
        end
    end

    return inputCleanedArray
end

function processMandatoryUserInput(inputString)
    local  inputCleanedArray = mandatoryUserInputCleaning(inputString)
    local imageCodeArray = {}

    for index=1, #inputCleanedArray do
        if inputCleanedArray[index][1] ~= missingImageKey then -- code needs to be added to support TikZ images 
            local singleImageCodeGraphicsEnd = graphicsMiddle .. inputCleanedArray[index][1] .. graphicsEnd
            singleImageCodeGraphicsEnd = singleImageCodeGraphicsEnd:gsub("{ ", "{") -- fixing issues with white space after {
            local singleImageCodeArray = {graphicsStart, singleImageCodeGraphicsEnd}
            table.insert(imageCodeArray,singleImageCodeArray)
        end
    end

    return {imageCodeArray}

end

function processOptionalUserInput(inputString)
    local layoutSpecifiedBool = false
    local rowsMax = 1
    local colsMax = 1
    local totalNumberOfImages = 1

    if inputString ~= "" then
        -- if more keywords/options allowed: first split at "," needs to be implemented
        stringAsArray = splitStringIntoTable(inputString, "=")

        if stringRegex(stringAsArray[1], gridKey) == true then
            layoutSpecifiedBool = true

            rowsMaxAndcolsMax = splitStringIntoTable(stringAsArray[2], layoutRowcolsMaxepKey)
            rowsMax = math.tointeger(rowsMaxAndcolsMax[1])
            colsMax = math.tointeger(rowsMaxAndcolsMax[2])
            totalNumberOfImages = rowsMax * colsMax
        end
    end

    return {layoutSpecifiedBool, rowsMax, colsMax, totalNumberOfImages}
end

function generateSubfigureCodeWithoutImages(layoutSpecifiedBool, rowsMax, colsMax, numberOfImages, subfigDefaultWidthFactor)
    -- templates for the different subfigure end formatting options
    local singleSubfigNoSpacerTEMPLATEArray = {subfigEnvStart, subfigEnvWidthEnd, subfigEnvEnd, ""}
    local singleSubfigVerticalSpacerTEMPLATEArray = {subfigEnvStart, subfigEnvWidthEnd, subfigEnvEnd, subfigVerticalSpacer}
    local singleSubfigHorizontalSpacerTEMPLATEArray ={subfigEnvStart, subfigEnvWidthEnd, subfigEnvEnd, subfigHorizontalSpacer}

    local modcolsMaxNumberOfImages = numberOfImages % colsMax

    local subfigCodeWithoutImagesArray = {}
    local indexCorrection = 0

    -- treat the special case first row, which might have different amount of cols 
    -- due to even/odd number of images not fitting with the row/col layout
    if modcolsMaxNumberOfImages ~= 0 then 
        -- number of images is not an integer multiple of columns
        -- -> less horizontal spacers/images and earlier line break than in the other rows
        for col=1, modcolsMaxNumberOfImages do
            if col < modcolsMaxNumberOfImages then
                if modcolsMaxNumberOfImages ~= 1 then
                    local customHspaceWidth = (1 - (modcolsMaxNumberOfImages * subfigDefaultWidthFactor + subfigDefaultHorizontalSpacerFactor * (modcolsMaxNumberOfImages-1)))/(colsMax) -- only works if no image width/height specified
                    local customHspaceString = "\\hspace{" .. subfigDefaultHorizontalSpacerFactor .. "\\linewidth}" -- customHspaceWidth

                    table.insert(subfigCodeWithoutImagesArray,{subfigEnvStart, subfigEnvWidthEnd, subfigEnvEnd, customHspaceString})
                else
                    if rowsMax ~= 1 then
                        table.insert(subfigCodeWithoutImagesArray,singleSubfigVerticalSpacerTEMPLATEArray)
                    else
                        table.insert(subfigCodeWithoutImagesArray,singleSubfigNoSpacerTEMPLATEArray)
                    end
                end
            else
                if row ~= rowsMax then
                    table.insert(subfigCodeWithoutImagesArray,singleSubfigVerticalSpacerTEMPLATEArray)
                else
                    table.insert(subfigCodeWithoutImagesArray,singleSubfigNoSpacerTEMPLATEArray)
                end
            end
        end
    else
        -- case when mod = 0 -> Number of images integer multiple of cols -> no special formatting required
        for col=1, colsMax do
            if col < colsMax then
                table.insert(subfigCodeWithoutImagesArray,singleSubfigHorizontalSpacerTEMPLATEArray)
            else
                if row ~= rowsMax then
                    table.insert(subfigCodeWithoutImagesArray,singleSubfigVerticalSpacerTEMPLATEArray)
                else
                    table.insert(subfigCodeWithoutImagesArray,singleSubfigNoSpacerTEMPLATEArray)
                end
            end
        end
    end

    -- general case for all other rows 
    for row=2, rowsMax do
        for col=1, colsMax do
            if col < colsMax then
                table.insert(subfigCodeWithoutImagesArray,singleSubfigHorizontalSpacerTEMPLATEArray)
            else
                if row ~= rowsMax then
                    table.insert(subfigCodeWithoutImagesArray,singleSubfigVerticalSpacerTEMPLATEArray)
                else
                    table.insert(subfigCodeWithoutImagesArray,singleSubfigNoSpacerTEMPLATEArray)
                end
            end
        end
    end

    return subfigCodeWithoutImagesArray
end

-- function containing the logic to generate and print the LaTeX code
function typesetFigure(mandatoryUserInputRawString,optionalUserInputRawString,label,caption)
    local mandatoryData = processMandatoryUserInput(mandatoryUserInputRawString)
    local img = mandatoryData[1] -- get image array data

    local optionalData = processOptionalUserInput(optionalUserInputRawString)
    local layoutSpecifiedBool = optionalData[1] -- obtain information whether user specified layout options

    local rowsMax = 1
    local colsMax = 1
    local numberOfImages = 1

    if layoutSpecifiedBool ~= false then -- if layout option specified
        -- copy rowsMax and colsMax from optional data
        rowsMax = optionalData[2] 
        colsMax = optionalData[3]

        -- check which number is smaller to avoid issues with nil errors
        -- future: load missing graphics
        if optionalData[4] < #img then
            numberOfImages = optionalData[4]
        else
            numberOfImages = #img
        end
    else -- when no layout specified, set defaults (colsMax = 2, number of images from mandatory input)
        colsMax = 2
        numberOfImages = #img

        local modcolsMaxNumberOfImages = numberOfImages % colsMax
        
        -- calculate the max number of rows considering odd/even number of images
        rowsMax = (numberOfImages - modcolsMaxNumberOfImages)/colsMax + modcolsMaxNumberOfImages
    end

    -- need to add code for width/height/aspect ratio calculation
    -- hard coded as long as no specifc styling of single elements allowed
    local subfigDefaultWidthFactor = (subfigMaxUseableWidthFactor - (colsMax-1) * subfigDefaultHorizontalSpacerFactor)/colsMax
    local subfigDefaultWidthString = subfigDefaultWidthFactor .. subfigWidthAndHorizontalSpacerUnit
    local subfigWidth = {subfigDefaultWidthString}
    local imgWidth = {"width=\\linewidth"}

    local subfigureCodeArray = generateSubfigureCodeWithoutImages(layoutSpecifiedBool, rowsMax, colsMax, numberOfImages, subfigDefaultWidthFactor)

    

    local commandString = figEnvStart -- initialize command string with start of fig env

    -- iterate over the complete image/subfigure data to assemble command string
    for imgIndex=1, numberOfImages do
        -- create the strings for one subfigure with image content
        local subfigurePrefix = subfigureCodeArray[imgIndex][1] .. subfigWidth[1] .. subfigureCodeArray[imgIndex][2]
        local subfigureSuffix = subfigureCodeArray[imgIndex][3] .. subfigureCodeArray[imgIndex][4]
        local imageString = img[imgIndex][1] .. imgWidth[1] .. img[imgIndex][2]

        -- append them to the command string from the previous stage
        commandString = commandString .. subfigurePrefix .. imageString  .. subfigureSuffix
    end

    -- determine whether caption and/or label are provided
    local captionAndLabelString =""
    if caption ~= "" then
        captionAndLabelString = captionAndLabelString .. "\\caption{" .. caption .. "}"
        if label ~= "" then
            captionAndLabelString = captionAndLabelString .. "\\label{" .. label .. "}"
        end
    end

    commandString = commandString .. captionAndLabelString .. figEnvEnd -- add caption/label (if applicable) and terminate fig env
    tex.sprint(commandString) -- print the assemble command to the TeX console
end

--+++Complete+++