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
-- function to determine number of columns, maximum rows in file and extract header
function generateNumberOfColsMaxRowsAndRawHeader(filename)
    local maxRows = 0
    local columns = 0
    local rawHeader = ""
    local tableHeader = ""

    local input = io.open(filename, 'r') -- open the csv file locally
    for line in input:lines() do -- go through the file line by line
        maxRows = maxRows + 1 -- increment the row counter to obtain the total number of files after for loop has finished
        if maxRows == 1 then -- when first line is processed
            rawHeader = line -- set the current line as unprocessed header

            -- replace the "," from the csv file with nothing to get a string which is similar to a lua function argument input
            -- then use select to determine the number of arguments passed to it to obtain the final number of columns - 1
            columns= select(2, string.gsub(line, ",", "")) + 1 
        end
    end	 
    input:close() -- close the file

    -- replace the "," from the csv with " & " to be compliant with the LaTeX table column seperator syntax; 
    -- "\\bfseries" ensures that the cell will be typeset in bold; note that "\\" required for escaping
    rawHeader = rawHeader:gsub(",", " & \\bfseries ") 

    -- since replacing "," with " & \\bfseries " works not for the first column (no "," available),
    -- add  "\\bfseries " manually to the beginning of the table header string
    tableHeader = "\\bfseries " .. rawHeader 

    return columns, maxRows, tableHeader
end

function validateColAlign(colAlignSTRING, columns)
    local actualVal = 0
    local colAlignTABLE = {}
    -- local wrongSpecifiers = {} -- for improvement of error message in a later version

    if colAlignSTRING ~= "" then -- when there was a column alignment specified
        if string.len(colAlignSTRING) == columns then -- if the length of the column alignment string matches the number of columns
            for i = 1, string.len(colAlignSTRING) do
                table.insert(colAlignTABLE,string.sub(colAlignSTRING, i, i))
            end
        elseif string.len(colAlignSTRING) > columns then
            for i = 1, columns do
                table.insert(colAlignTABLE,string.sub(colAlignSTRING, i, i))
            end
        else
            for i = 1, columns do
                if i <= string.len(colAlignSTRING) then
                    table.insert(colAlignTABLE,string.sub(colAlignSTRING, i, i))
                else
                    table.insert(colAlignTABLE,"l")
                end
            end
        end
    else
        for i = 1, columns do
            table.insert(colAlignTABLE,"l")
        end
    end

    for col = 1, #colAlignTABLE do 
        if colAlignTABLE[col] == "r" or colAlignTABLE[col] == "l" or colAlignTABLE[col] == "c" then
            actualVal = actualVal + 1
        else
            -- table.insert(wrongSpecifiers,colAlignTABLE[col]) -- for improvement of error message in a later version
            colAlignTABLE[col] = "l"
        end
    end
    
    local numberWrongSpecifier = columns - actualVal
    local timesHelper = ""
    
    if numberWrongSpecifier == 1 then
        timesHelper = numberWrongSpecifier .. " time"
    else
        timesHelper = numberWrongSpecifier .. " times"
    end
    
    local warningMessage = "docART:WARNING: tables/columns/align: " .. timesHelper .. " invalid column alignment option specified. Used \"l\" instead. \n\n"

    if numberWrongSpecifier ~= 0 then
        texio.write(warningMessage)
    end

    return colAlignTABLE
end

function generateCaptionAndLabel(label,caption, captionStatus)
    local captionAndLabelAbove = "" 
    local captionAndLabelBelow = ""
    local captionAndLabel  = ""
    local headCaption = ""
    local headCaptionPre = [[\tablename \]]
    local headCaptionPost = [[ continued from previous page.]]

    if captionStatus ~= "nocaption" then
        headCaption = headCaptionPre .. [[ \thetable{}]] .. headCaptionPost
        captionAndLabel = [[\caption{]] .. caption .. "}"
        if label ~= "" then
            captionAndLabel = captionAndLabel .. [[\label{]] .. label .. "}"
        end
        if captionStatus == "captionabove" then
            captionAndLabelAbove = captionAndLabel .. "\\\\[0.5cm]"
        else
            captionAndLabelBelow = captionAndLabel
        end
    else
        captionAndLabelAbove = ""
        captionAndLabelBelow = ""
        headCaption = headCaptionPre .. headCaptionPost
    end

    return captionAndLabelAbove, captionAndLabelBelow, headCaption
end

function setTableRowHighlightColors(captionStatus)
    if captionStatus ~= "nocaption" then
        tex.sprint([[\rowcolors{2}{white}{tableRowHighlightColor}]])
    else
        tex.sprint([[\rowcolors{2}{tableRowHighlightColor}{white}]])
    end
end

function parseAndGenerateTablePreambleAndMetric(filename, colAlignSTRING, label,caption, captionStatus)
    columns, maxRows, tableHeader = generateNumberOfColsMaxRowsAndRawHeader(filename)
    
    colAlignTABLE = validateColAlign(colAlignSTRING, columns)
    colAlignFINAL = table.concat(colAlignTABLE)
    
    captionAndLabelAbove, captionAndLabelBelow, headCaption = generateCaptionAndLabel(label,caption, captionStatus)
    
    setTableRowHighlightColors(captionStatus)
    
    tex.sprint("\\def\\filename{".. filename .."}")
    tex.sprint("\\def\\columns{" .. columns .. "}")
    tex.sprint("\\def\\maxRows{" .. maxRows .. "}")
    tex.sprint("\\def\\colAlign{" .. colAlignFINAL .. "}")
    tex.sprint("\\def\\tableHeader{".. tableHeader .."}")
    tex.sprint("\\def\\captionAndLabelAbove{" .. captionAndLabelAbove .. "}")
    tex.sprint("\\def\\captionAndLabelBelow{" .. captionAndLabelBelow .. "}")
    tex.sprint("\\def\\headCaption{" .. headCaption .. "}")
    tex.sprint("\\tabulinesep=1.2mm") -- for better spacing around lines
    tex.sprint("\\begin{longtable}[c]{" .. colAlignFINAL .. "}")
end

function parseAndGenerateTableData(filename,maxRows)
    local counter = 0
    local tableData = ""

    local input = io.open(filename, 'r')
    for line in input:lines() do
        if counter > 0 then
            tableData = line
            tableData=tableData:gsub(",", " & ")
            if counter < maxRows-1 then
                tex.sprint(tableData .. " \\\\")
            else
                tex.sprint(tableData)
            end
        end
        counter = counter + 1
    end
    input:close()
end

--+++Complete+++