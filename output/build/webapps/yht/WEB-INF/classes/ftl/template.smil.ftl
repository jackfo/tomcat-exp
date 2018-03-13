<?xml version="1.0" encoding="utf-8"?>
<smil>
<head>
<meta name="title" content="${smil.title}" />
<meta name="author" content="${smil.author}" />
<layout>
<root-layout width="${smil.width}" height="${smil.height}" />
<region id="top0" width="${smil.width}" height="${smil.height/2}" left="0" top="0" />
<region id="bottom0" width="${smil.width}" height="${smil.height/2}" left="0" top="${smil.height/2}" />
</layout>
</head>
<body>
<#list  smil.pars as obj>
<par dur="${obj.dur}">
<#if obj.img?? && obj.img!=''>
<img src="${obj.img}" region="${obj.imgRegion}" />
</#if >
<#if obj.txt?? && obj.txt!=''>
<text src="${obj.txt}" region="${obj.txtRegion}" />
</#if >
<#if obj.audio?? && obj.audio!=''>
<audio src="${obj.audio}" />
</#if >
</par>
</#list>
</body>
</smil>