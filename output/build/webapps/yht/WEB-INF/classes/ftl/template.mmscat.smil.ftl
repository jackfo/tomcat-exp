<?xml version="1.0" ?>
<smil>
<head/>
<body>
<#list  smil.pars as obj>
<par dur="${obj.dur}">
<#if obj.img?? && obj.img!=''>
<img src="${obj.img}"  />
</#if >
<#if obj.txt?? && obj.txt!=''>
<text src="${obj.txt}"  />
</#if >
<#if obj.audio?? && obj.audio!=''>
<audio src="${obj.audio}" />
</#if >
</par>
</#list>
</body>
</smil>