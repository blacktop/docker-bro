@load base/files/extract

global mime_to_ext: table[string] of string = {
	["application/x-dosexec"] = "exe",
	["application/zip"] = "zip",
	["multipart/x-zip"] = "zip",
	["multipart/x-gzip"] = "gzip",
	["audio/x-mpeg"] = "mp3",
	["audio/x-wav"] = "wav",
	["image/bmp"] = "bmp",
	["image/gif"] = "gif",
	["text/plain"] = "txt",
	["application/rtf"] = "rtf",
	["application/x-sh"] = "sh",
	["application/x-javascript"] = "js",
	["application/x-shockwave-flash"] = "swf",
	["image/jpeg"] = "jpg",
	["image/png"] = "png",
	["text/html"] = "html",
	["application/pdf"] = "pdf",
};

event file_sniff(f: fa_file, meta: fa_metadata)
	{
	if ( f$source != "HTTP" )
		return;

	if ( ! meta?$mime_type )
		return;

	if ( meta$mime_type !in mime_to_ext )
		return;

	local fname = fmt("%s-%s.%s", f$source, f$id, mime_to_ext[meta$mime_type]);
	print fmt("Extracting file %s", fname);
	Files::add_analyzer(f, Files::ANALYZER_EXTRACT, [$extract_filename=fname]);
	}
