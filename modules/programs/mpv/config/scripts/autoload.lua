-- This script automatically loads playlist entries before and after the
-- the currently played file. It does so by scanning the directory a file is
-- located in when starting playback. It sorts the directory entries
-- alphabetically, and adds entries before and after the current file to
-- the internal playlist. (It stops if it would add an already existing
-- playlist entry at the same position - this makes it "stable".)
-- Add at most 5000 * 2 files when starting a file (before + after).

--[[
To configure this script use file autoload.conf in directory script-opts (the "script-opts"
directory must be in the mpv configuration directory, typically ~/.config/mpv/).

Example configuration would be:

disabled=no
images=no
videos=yes
audio=yes
ignore_hidden=yes

--]]

-- !! Minified !!
MAXENTRIES=5000;local a=require'mp.msg'local b=require'mp.options'local c=require'mp.utils'o={disabled=false,images=true,videos=true,audio=true,ignore_hidden=true}b.read_options(o)function Set(d)local e={}for f,g in pairs(d)do e[g]=true end;return e end;function SetUnion(h,i)local j={}for k in pairs(h)do j[k]=true end;for k in pairs(i)do j[k]=true end;return j end;EXTENSIONS_VIDEO=Set{'3g2','3gp','avi','flv','m2ts','m4v','mj2','mkv','mov','mp4','mpeg','mpg','ogv','rmvb','webm','wmv','y4m'}EXTENSIONS_AUDIO=Set{'aiff','ape','au','flac','m4a','mka','mp3','oga','ogg','ogm','opus','wav','wma'}EXTENSIONS_IMAGES=Set{'avif','bmp','gif','j2k','jp2','jpeg','jpg','jxl','png','svg','tga','tif','tiff','webp'}EXTENSIONS=Set{}if o.videos then EXTENSIONS=SetUnion(EXTENSIONS,EXTENSIONS_VIDEO)end;if o.audio then EXTENSIONS=SetUnion(EXTENSIONS,EXTENSIONS_AUDIO)end;if o.images then EXTENSIONS=SetUnion(EXTENSIONS,EXTENSIONS_IMAGES)end;function add_files_at(l,m)l=l-1;local n=mp.get_property_number("playlist-count",1)for p=1,#m do mp.commandv("loadfile",m[p],"append")mp.commandv("playlist-move",n+p-1,l+p-1)end end;function get_extension(q)match=string.match(q,"%.([^%.]+)$")if match==nil then return"nomatch"else return match end end;table.filter=function(d,r)for p=#d,1,-1 do if not r(d[p])then table.remove(d,p)end end end;function alphanumsort(s)local function t(u,v)return#v>0 and("%03d%s%.12f"):format(#u,u,tonumber(v)/10^#v)or("%03d%s"):format(#u,u)end;local w={}for p,x in ipairs(s)do w[p]={x:lower():gsub("0*(%d+)%.?(%d*)",t),x}end;table.sort(w,function(h,i)return h[1]==i[1]and#i[2]<#h[2]or h[1]<i[1]end)for p,y in ipairs(w)do s[p]=y[2]end;return s end;local z=nil;function get_playlist_filenames()local s={}for u=0,pl_count-1,1 do local A=mp.get_property('playlist/'..u..'/filename')local f,B=c.split_path(A)s[B]=true end;return s end;function find_and_add_entries()local q=mp.get_property("path","")local C,A=c.split_path(q)a.trace(("dir: %s, filename: %s"):format(C,A))if o.disabled then a.verbose("stopping: autoload disabled")return elseif#C==0 then a.verbose("stopping: not a local path")return end;pl_count=mp.get_property_number("playlist-count",1)if pl_count>1 and z==nil or pl_count==1 and EXTENSIONS[string.lower(get_extension(A))]==nil then a.verbose("stopping: manually made playlist")return else z=true end;local D=mp.get_property_native("playlist",{})local E=mp.get_property_number("playlist-pos-1",1)a.trace(("playlist-pos-1: %s, playlist: %s"):format(E,c.to_string(D)))local m=c.readdir(C,"files")if m==nil then a.verbose("no other files in directory")return end;table.filter(m,function(g,k)if o.ignore_hidden and not(g==A)and string.match(g,"^%.")then return false end;local F=get_extension(g)if F==nil then return false end;return EXTENSIONS[string.lower(F)]end)alphanumsort(m)if C=="."then C=""end;local G;for p=1,#m do if m[p]==A then G=p;break end end;if G==nil then return end;a.trace("current file position in files: "..G)local H={[-1]={},[1]={}}local s=get_playlist_filenames()for I=-1,1,2 do for p=1,MAXENTRIES do local B=m[G+p*I]if B==nil or B[1]=="."then break end;local J=C..B;if s[B]then break end;if I==-1 then if E==1 then a.info("Prepending "..B)table.insert(H[-1],1,J)end else a.info("Adding "..B)table.insert(H[1],J)end end end;add_files_at(E+1,H[1])add_files_at(E,H[-1])end;mp.register_event("start-file",find_and_add_entries)