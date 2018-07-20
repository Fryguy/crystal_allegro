@[Link("allegro")]
@[Link("allegro_acodec")]
@[Link("allegro_audio")]
@[Link("allegro_color")]
@[Link("allegro_dialog")]
@[Link("allegro_font")]
@[Link("allegro_image")]
@[Link("allegro_primitives")]
{% if flag?(:darwin) %}
  @[Link(ldflags: "-L`xcode-select --print-path`/usr/lib")]
  @[Link(ldflags: "-rpath `xcode-select --print-path`/usr/lib")]
{% else %}
  @[Link(ldflags: "`llvm-config-3.6 --ldflags 2>/dev/null || llvm-config-3.5 --ldflags 2>/dev/null || llvm-config --ldflags 2>/dev/null`")]
{% end %}
lib LibAllegro
  VERSION                     =                      5
  SUB_VERSION                 =                      2
  WIP_VERSION                 =                      4
  UNSTABLE_BIT                =                      0
  RELEASE_NUMBER              =                      1
  DATE                        =               20180224
  PI                          = 3.14159265358979323846
  NEW_WINDOW_TITLE_MAX_SIZE   =                    255
  MOUSE_MAX_EXTRA_AXES        =                      4
  TOUCH_INPUT_MAX_TOUCH_COUNT =                     16
  MAX_CHANNELS                =                      8
  VERTEX_CACHE_SIZE           =                    256
  PRIM_QUALITY                =                     10
  fun get_allegro_version = al_get_allegro_version : Uint32T
  alias Uint32T = LibC::UInt
  fun run_main = al_run_main(argc : LibC::Int, argv : LibC::Char**, x2 : (LibC::Int, LibC::Char** -> LibC::Int)) : LibC::Int

  struct Timeout
    __pad1__ : Uint64T
    __pad2__ : Uint64T
  end

  alias Uint64T = LibC::ULongLong
  fun get_time = al_get_time : LibC::Double
  fun rest = al_rest(seconds : LibC::Double)
  fun init_timeout = al_init_timeout(timeout : Timeout*, seconds : LibC::Double)

  struct Color
    r : LibC::Float
    g : LibC::Float
    b : LibC::Float
    a : LibC::Float
  end

  fun map_rgb = al_map_rgb(r : UInt8, g : UInt8, b : UInt8) : Color
  fun map_rgba = al_map_rgba(r : UInt8, g : UInt8, b : UInt8, a : UInt8) : Color
  fun map_rgb_f = al_map_rgb_f(r : LibC::Float, g : LibC::Float, b : LibC::Float) : Color
  fun map_rgba_f = al_map_rgba_f(r : LibC::Float, g : LibC::Float, b : LibC::Float, a : LibC::Float) : Color
  fun premul_rgba = al_premul_rgba(r : UInt8, g : UInt8, b : UInt8, a : UInt8) : Color
  fun premul_rgba_f = al_premul_rgba_f(r : LibC::Float, g : LibC::Float, b : LibC::Float, a : LibC::Float) : Color
  fun unmap_rgb = al_unmap_rgb(color : Color, r : UInt8*, g : UInt8*, b : UInt8*)
  fun unmap_rgba = al_unmap_rgba(color : Color, r : UInt8*, g : UInt8*, b : UInt8*, a : UInt8*)
  fun unmap_rgb_f = al_unmap_rgb_f(color : Color, r : LibC::Float*, g : LibC::Float*, b : LibC::Float*)
  fun unmap_rgba_f = al_unmap_rgba_f(color : Color, r : LibC::Float*, g : LibC::Float*, b : LibC::Float*, a : LibC::Float*)
  fun get_pixel_size = al_get_pixel_size(format : LibC::Int) : LibC::Int
  fun get_pixel_format_bits = al_get_pixel_format_bits(format : LibC::Int) : LibC::Int
  fun get_pixel_block_size = al_get_pixel_block_size(format : LibC::Int) : LibC::Int
  fun get_pixel_block_width = al_get_pixel_block_width(format : LibC::Int) : LibC::Int
  fun get_pixel_block_height = al_get_pixel_block_height(format : LibC::Int) : LibC::Int
  MemoryBitmap           =    1_i64
  X_KeepBitmapFormat     =    2_i64
  ForceLocking           =    4_i64
  NoPreserveTexture      =    8_i64
  X_AlphaTest            =   16_i64
  X_InternalOpengl       =   32_i64
  MinLinear              =   64_i64
  MagLinear              =  128_i64
  Mipmap                 =  256_i64
  X_NoPremultipliedAlpha =  512_i64
  VideoBitmap            = 1024_i64
  ConvertBitmap          = 4096_i64
  fun set_new_bitmap_format = al_set_new_bitmap_format(format : LibC::Int)
  fun set_new_bitmap_flags = al_set_new_bitmap_flags(flags : LibC::Int)
  fun get_new_bitmap_format = al_get_new_bitmap_format : LibC::Int
  fun get_new_bitmap_flags = al_get_new_bitmap_flags : LibC::Int
  fun add_new_bitmap_flag = al_add_new_bitmap_flag(flag : LibC::Int)
  fun get_bitmap_width = al_get_bitmap_width(bitmap : Bitmap) : LibC::Int
  type Bitmap = Void*
  fun get_bitmap_height = al_get_bitmap_height(bitmap : Bitmap) : LibC::Int
  fun get_bitmap_format = al_get_bitmap_format(bitmap : Bitmap) : LibC::Int
  fun get_bitmap_flags = al_get_bitmap_flags(bitmap : Bitmap) : LibC::Int
  fun create_bitmap = al_create_bitmap(w : LibC::Int, h : LibC::Int) : Bitmap
  fun destroy_bitmap = al_destroy_bitmap(bitmap : Bitmap)
  fun put_pixel = al_put_pixel(x : LibC::Int, y : LibC::Int, color : Color)
  fun put_blended_pixel = al_put_blended_pixel(x : LibC::Int, y : LibC::Int, color : Color)
  fun get_pixel = al_get_pixel(bitmap : Bitmap, x : LibC::Int, y : LibC::Int) : Color
  fun convert_mask_to_alpha = al_convert_mask_to_alpha(bitmap : Bitmap, mask_color : Color)
  fun set_clipping_rectangle = al_set_clipping_rectangle(x : LibC::Int, y : LibC::Int, width : LibC::Int, height : LibC::Int)
  fun reset_clipping_rectangle = al_reset_clipping_rectangle
  fun get_clipping_rectangle = al_get_clipping_rectangle(x : LibC::Int*, y : LibC::Int*, w : LibC::Int*, h : LibC::Int*)
  fun create_sub_bitmap = al_create_sub_bitmap(parent : Bitmap, x : LibC::Int, y : LibC::Int, w : LibC::Int, h : LibC::Int) : Bitmap
  fun is_sub_bitmap = al_is_sub_bitmap(bitmap : Bitmap) : LibC::Bool
  fun get_parent_bitmap = al_get_parent_bitmap(bitmap : Bitmap) : Bitmap
  fun get_bitmap_x = al_get_bitmap_x(bitmap : Bitmap) : LibC::Int
  fun get_bitmap_y = al_get_bitmap_y(bitmap : Bitmap) : LibC::Int
  fun reparent_bitmap = al_reparent_bitmap(bitmap : Bitmap, parent : Bitmap, x : LibC::Int, y : LibC::Int, w : LibC::Int, h : LibC::Int)
  fun clone_bitmap = al_clone_bitmap(bitmap : Bitmap) : Bitmap
  fun convert_bitmap = al_convert_bitmap(bitmap : Bitmap)
  fun convert_memory_bitmaps = al_convert_memory_bitmaps
  FlipHorizontal = 1_i64
  FlipVertical = 2_i64
  fun draw_bitmap = al_draw_bitmap(bitmap : Bitmap, dx : LibC::Float, dy : LibC::Float, flags : LibC::Int)
  fun draw_bitmap_region = al_draw_bitmap_region(bitmap : Bitmap, sx : LibC::Float, sy : LibC::Float, sw : LibC::Float, sh : LibC::Float, dx : LibC::Float, dy : LibC::Float, flags : LibC::Int)
  fun draw_scaled_bitmap = al_draw_scaled_bitmap(bitmap : Bitmap, sx : LibC::Float, sy : LibC::Float, sw : LibC::Float, sh : LibC::Float, dx : LibC::Float, dy : LibC::Float, dw : LibC::Float, dh : LibC::Float, flags : LibC::Int)
  fun draw_rotated_bitmap = al_draw_rotated_bitmap(bitmap : Bitmap, cx : LibC::Float, cy : LibC::Float, dx : LibC::Float, dy : LibC::Float, angle : LibC::Float, flags : LibC::Int)
  fun draw_scaled_rotated_bitmap = al_draw_scaled_rotated_bitmap(bitmap : Bitmap, cx : LibC::Float, cy : LibC::Float, dx : LibC::Float, dy : LibC::Float, xscale : LibC::Float, yscale : LibC::Float, angle : LibC::Float, flags : LibC::Int)
  fun draw_tinted_bitmap = al_draw_tinted_bitmap(bitmap : Bitmap, tint : Color, dx : LibC::Float, dy : LibC::Float, flags : LibC::Int)
  fun draw_tinted_bitmap_region = al_draw_tinted_bitmap_region(bitmap : Bitmap, tint : Color, sx : LibC::Float, sy : LibC::Float, sw : LibC::Float, sh : LibC::Float, dx : LibC::Float, dy : LibC::Float, flags : LibC::Int)
  fun draw_tinted_scaled_bitmap = al_draw_tinted_scaled_bitmap(bitmap : Bitmap, tint : Color, sx : LibC::Float, sy : LibC::Float, sw : LibC::Float, sh : LibC::Float, dx : LibC::Float, dy : LibC::Float, dw : LibC::Float, dh : LibC::Float, flags : LibC::Int)
  fun draw_tinted_rotated_bitmap = al_draw_tinted_rotated_bitmap(bitmap : Bitmap, tint : Color, cx : LibC::Float, cy : LibC::Float, dx : LibC::Float, dy : LibC::Float, angle : LibC::Float, flags : LibC::Int)
  fun draw_tinted_scaled_rotated_bitmap = al_draw_tinted_scaled_rotated_bitmap(bitmap : Bitmap, tint : Color, cx : LibC::Float, cy : LibC::Float, dx : LibC::Float, dy : LibC::Float, xscale : LibC::Float, yscale : LibC::Float, angle : LibC::Float, flags : LibC::Int)
  fun draw_tinted_scaled_rotated_bitmap_region = al_draw_tinted_scaled_rotated_bitmap_region(bitmap : Bitmap, sx : LibC::Float, sy : LibC::Float, sw : LibC::Float, sh : LibC::Float, tint : Color, cx : LibC::Float, cy : LibC::Float, dx : LibC::Float, dy : LibC::Float, xscale : LibC::Float, yscale : LibC::Float, angle : LibC::Float, flags : LibC::Int)

  struct X_Tagbstring
    mlen : LibC::Int
    slen : LibC::Int
    data : UInt8*
  end

  fun ustr_new = al_ustr_new(s : LibC::Char*) : Ustr*
  type Ustr = X_Tagbstring
  fun ustr_new_from_buffer = al_ustr_new_from_buffer(s : LibC::Char*, size : LibC::SizeT) : Ustr*
  fun ustr_newf = al_ustr_newf(fmt : LibC::Char*, ...) : Ustr*
  fun ustr_free = al_ustr_free(us : Ustr*)
  fun cstr = al_cstr(us : Ustr*) : LibC::Char*
  fun ustr_to_buffer = al_ustr_to_buffer(us : Ustr*, buffer : LibC::Char*, size : LibC::Int)
  fun cstr_dup = al_cstr_dup(us : Ustr*) : LibC::Char*
  fun ustr_dup = al_ustr_dup(us : Ustr*) : Ustr*
  fun ustr_dup_substr = al_ustr_dup_substr(us : Ustr*, start_pos : LibC::Int, end_pos : LibC::Int) : Ustr*
  fun ustr_empty_string = al_ustr_empty_string : Ustr*
  fun ref_cstr = al_ref_cstr(info : UstrInfo*, s : LibC::Char*) : Ustr*
  type UstrInfo = X_Tagbstring
  fun ref_buffer = al_ref_buffer(info : UstrInfo*, s : LibC::Char*, size : LibC::SizeT) : Ustr*
  fun ref_ustr = al_ref_ustr(info : UstrInfo*, us : Ustr*, start_pos : LibC::Int, end_pos : LibC::Int) : Ustr*
  fun ustr_size = al_ustr_size(us : Ustr*) : LibC::SizeT
  fun ustr_length = al_ustr_length(us : Ustr*) : LibC::SizeT
  fun ustr_offset = al_ustr_offset(us : Ustr*, index : LibC::Int) : LibC::Int
  fun ustr_next = al_ustr_next(us : Ustr*, pos : LibC::Int*) : LibC::Bool
  fun ustr_prev = al_ustr_prev(us : Ustr*, pos : LibC::Int*) : LibC::Bool
  fun ustr_get = al_ustr_get(us : Ustr*, pos : LibC::Int) : Int32T
  alias Int32T = LibC::Int
  fun ustr_get_next = al_ustr_get_next(us : Ustr*, pos : LibC::Int*) : Int32T
  fun ustr_prev_get = al_ustr_prev_get(us : Ustr*, pos : LibC::Int*) : Int32T
  fun ustr_insert = al_ustr_insert(us1 : Ustr*, pos : LibC::Int, us2 : Ustr*) : LibC::Bool
  fun ustr_insert_cstr = al_ustr_insert_cstr(us : Ustr*, pos : LibC::Int, us2 : LibC::Char*) : LibC::Bool
  fun ustr_insert_chr = al_ustr_insert_chr(us : Ustr*, pos : LibC::Int, c : Int32T) : LibC::SizeT
  fun ustr_append = al_ustr_append(us1 : Ustr*, us2 : Ustr*) : LibC::Bool
  fun ustr_append_cstr = al_ustr_append_cstr(us : Ustr*, s : LibC::Char*) : LibC::Bool
  fun ustr_append_chr = al_ustr_append_chr(us : Ustr*, c : Int32T) : LibC::SizeT
  fun ustr_appendf = al_ustr_appendf(us : Ustr*, fmt : LibC::Char*, ...) : LibC::Bool
  fun ustr_vappendf = al_ustr_vappendf(us : Ustr*, fmt : LibC::Char*, ap : VaList) : LibC::Bool
  alias VaList = LibC::VaList
  fun ustr_remove_chr = al_ustr_remove_chr(us : Ustr*, pos : LibC::Int) : LibC::Bool
  fun ustr_remove_range = al_ustr_remove_range(us : Ustr*, start_pos : LibC::Int, end_pos : LibC::Int) : LibC::Bool
  fun ustr_truncate = al_ustr_truncate(us : Ustr*, start_pos : LibC::Int) : LibC::Bool
  fun ustr_ltrim_ws = al_ustr_ltrim_ws(us : Ustr*) : LibC::Bool
  fun ustr_rtrim_ws = al_ustr_rtrim_ws(us : Ustr*) : LibC::Bool
  fun ustr_trim_ws = al_ustr_trim_ws(us : Ustr*) : LibC::Bool
  fun ustr_assign = al_ustr_assign(us1 : Ustr*, us2 : Ustr*) : LibC::Bool
  fun ustr_assign_substr = al_ustr_assign_substr(us1 : Ustr*, us2 : Ustr*, start_pos : LibC::Int, end_pos : LibC::Int) : LibC::Bool
  fun ustr_assign_cstr = al_ustr_assign_cstr(us1 : Ustr*, s : LibC::Char*) : LibC::Bool
  fun ustr_set_chr = al_ustr_set_chr(us : Ustr*, pos : LibC::Int, c : Int32T) : LibC::SizeT
  fun ustr_replace_range = al_ustr_replace_range(us1 : Ustr*, start_pos1 : LibC::Int, end_pos1 : LibC::Int, us2 : Ustr*) : LibC::Bool
  fun ustr_find_chr = al_ustr_find_chr(us : Ustr*, start_pos : LibC::Int, c : Int32T) : LibC::Int
  fun ustr_rfind_chr = al_ustr_rfind_chr(us : Ustr*, start_pos : LibC::Int, c : Int32T) : LibC::Int
  fun ustr_find_set = al_ustr_find_set(us : Ustr*, start_pos : LibC::Int, accept : Ustr*) : LibC::Int
  fun ustr_find_set_cstr = al_ustr_find_set_cstr(us : Ustr*, start_pos : LibC::Int, accept : LibC::Char*) : LibC::Int
  fun ustr_find_cset = al_ustr_find_cset(us : Ustr*, start_pos : LibC::Int, reject : Ustr*) : LibC::Int
  fun ustr_find_cset_cstr = al_ustr_find_cset_cstr(us : Ustr*, start_pos : LibC::Int, reject : LibC::Char*) : LibC::Int
  fun ustr_find_str = al_ustr_find_str(haystack : Ustr*, start_pos : LibC::Int, needle : Ustr*) : LibC::Int
  fun ustr_find_cstr = al_ustr_find_cstr(haystack : Ustr*, start_pos : LibC::Int, needle : LibC::Char*) : LibC::Int
  fun ustr_rfind_str = al_ustr_rfind_str(haystack : Ustr*, start_pos : LibC::Int, needle : Ustr*) : LibC::Int
  fun ustr_rfind_cstr = al_ustr_rfind_cstr(haystack : Ustr*, start_pos : LibC::Int, needle : LibC::Char*) : LibC::Int
  fun ustr_find_replace = al_ustr_find_replace(us : Ustr*, start_pos : LibC::Int, find : Ustr*, replace : Ustr*) : LibC::Bool
  fun ustr_find_replace_cstr = al_ustr_find_replace_cstr(us : Ustr*, start_pos : LibC::Int, find : LibC::Char*, replace : LibC::Char*) : LibC::Bool
  fun ustr_equal = al_ustr_equal(us1 : Ustr*, us2 : Ustr*) : LibC::Bool
  fun ustr_compare = al_ustr_compare(u : Ustr*, v : Ustr*) : LibC::Int
  fun ustr_ncompare = al_ustr_ncompare(us1 : Ustr*, us2 : Ustr*, n : LibC::Int) : LibC::Int
  fun ustr_has_prefix = al_ustr_has_prefix(u : Ustr*, v : Ustr*) : LibC::Bool
  fun ustr_has_prefix_cstr = al_ustr_has_prefix_cstr(u : Ustr*, s : LibC::Char*) : LibC::Bool
  fun ustr_has_suffix = al_ustr_has_suffix(u : Ustr*, v : Ustr*) : LibC::Bool
  fun ustr_has_suffix_cstr = al_ustr_has_suffix_cstr(us1 : Ustr*, s : LibC::Char*) : LibC::Bool
  fun utf8_width = al_utf8_width(c : Int32T) : LibC::SizeT
  fun utf8_encode = al_utf8_encode(s : LibC::Char*, c : Int32T) : LibC::SizeT
  fun ustr_new_from_utf16 = al_ustr_new_from_utf16(s : Uint16T*) : Ustr*
  alias Uint16T = LibC::UShort
  fun ustr_size_utf16 = al_ustr_size_utf16(us : Ustr*) : LibC::SizeT
  fun ustr_encode_utf16 = al_ustr_encode_utf16(us : Ustr*, s : Uint16T*, n : LibC::SizeT) : LibC::SizeT
  fun utf16_width = al_utf16_width(c : LibC::Int) : LibC::SizeT
  fun utf16_encode = al_utf16_encode(s : Uint16T*, c : Int32T) : LibC::SizeT
  fun create_path = al_create_path(str : LibC::Char*) : Path
  type Path = Void*
  fun create_path_for_directory = al_create_path_for_directory(str : LibC::Char*) : Path
  fun clone_path = al_clone_path(path : Path) : Path
  fun get_path_num_components = al_get_path_num_components(path : Path) : LibC::Int
  fun get_path_component = al_get_path_component(path : Path, i : LibC::Int) : LibC::Char*
  fun replace_path_component = al_replace_path_component(path : Path, i : LibC::Int, s : LibC::Char*)
  fun remove_path_component = al_remove_path_component(path : Path, i : LibC::Int)
  fun insert_path_component = al_insert_path_component(path : Path, i : LibC::Int, s : LibC::Char*)
  fun get_path_tail = al_get_path_tail(path : Path) : LibC::Char*
  fun drop_path_tail = al_drop_path_tail(path : Path)
  fun append_path_component = al_append_path_component(path : Path, s : LibC::Char*)
  fun join_paths = al_join_paths(path : Path, tail : Path) : LibC::Bool
  fun rebase_path = al_rebase_path(head : Path, tail : Path) : LibC::Bool
  fun path_cstr = al_path_cstr(path : Path, delim : LibC::Char) : LibC::Char*
  fun path_ustr = al_path_ustr(path : Path, delim : LibC::Char) : Ustr*
  fun destroy_path = al_destroy_path(path : Path)
  fun set_path_drive = al_set_path_drive(path : Path, drive : LibC::Char*)
  fun get_path_drive = al_get_path_drive(path : Path) : LibC::Char*
  fun set_path_filename = al_set_path_filename(path : Path, filename : LibC::Char*)
  fun get_path_filename = al_get_path_filename(path : Path) : LibC::Char*
  fun get_path_extension = al_get_path_extension(path : Path) : LibC::Char*
  fun set_path_extension = al_set_path_extension(path : Path, extension : LibC::Char*) : LibC::Bool
  fun get_path_basename = al_get_path_basename(path : Path) : LibC::Char*
  fun make_path_canonical = al_make_path_canonical(path : Path) : LibC::Bool

  struct FileInterface
    fi_fopen : (LibC::Char*, LibC::Char* -> Void*)
    fi_fclose : (File -> LibC::Bool)
    fi_fread : (File, Void*, LibC::SizeT -> LibC::SizeT)
    fi_fwrite : (File, Void*, LibC::SizeT -> LibC::SizeT)
    fi_fflush : (File -> LibC::Bool)
    fi_ftell : (File -> Int64T)
    fi_fseek : (File, Int64T, LibC::Int -> LibC::Bool)
    fi_feof : (File -> LibC::Bool)
    fi_ferror : (File -> LibC::Int)
    fi_ferrmsg : (File -> LibC::Char*)
    fi_fclearerr : (File -> Void)
    fi_fungetc : (File, LibC::Int -> LibC::Int)
    fi_fsize : (File -> OffT)
  end

  type File = Void*
  alias Int64T = LibC::LongLong
  alias X__Int64T = LibC::LongLong
  alias X__DarwinOffT = X__Int64T
  alias OffT = X__DarwinOffT
  fun fopen = al_fopen(path : LibC::Char*, mode : LibC::Char*) : File
  fun fopen_interface = al_fopen_interface(vt : FileInterface*, path : LibC::Char*, mode : LibC::Char*) : File
  fun create_file_handle = al_create_file_handle(vt : FileInterface*, userdata : Void*) : File
  fun fclose = al_fclose(f : File) : LibC::Bool
  fun fread = al_fread(f : File, ptr : Void*, size : LibC::SizeT) : LibC::SizeT
  fun fwrite = al_fwrite(f : File, ptr : Void*, size : LibC::SizeT) : LibC::SizeT
  fun fflush = al_fflush(f : File) : LibC::Bool
  fun ftell = al_ftell(f : File) : Int64T
  fun fseek = al_fseek(f : File, offset : Int64T, whence : LibC::Int) : LibC::Bool
  fun feof = al_feof(f : File) : LibC::Bool
  fun ferror = al_ferror(f : File) : LibC::Int
  fun ferrmsg = al_ferrmsg(f : File) : LibC::Char*
  fun fclearerr = al_fclearerr(f : File)
  fun fungetc = al_fungetc(f : File, c : LibC::Int) : LibC::Int
  fun fsize = al_fsize(f : File) : Int64T
  fun fgetc = al_fgetc(f : File) : LibC::Int
  fun fputc = al_fputc(f : File, c : LibC::Int) : LibC::Int
  fun fread16le = al_fread16le(f : File) : Int16T
  alias Int16T = LibC::Short
  fun fread16be = al_fread16be(f : File) : Int16T
  fun fwrite16le = al_fwrite16le(f : File, w : Int16T) : LibC::SizeT
  fun fwrite16be = al_fwrite16be(f : File, w : Int16T) : LibC::SizeT
  fun fread32le = al_fread32le(f : File) : Int32T
  fun fread32be = al_fread32be(f : File) : Int32T
  fun fwrite32le = al_fwrite32le(f : File, l : Int32T) : LibC::SizeT
  fun fwrite32be = al_fwrite32be(f : File, l : Int32T) : LibC::SizeT
  fun fgets = al_fgets(f : File, p : LibC::Char*, max : LibC::SizeT) : LibC::Char*
  fun fget_ustr = al_fget_ustr(f : File) : Ustr*
  fun fputs = al_fputs(f : File, p : LibC::Char*) : LibC::Int
  fun fprintf = al_fprintf(f : File, format : LibC::Char*, ...) : LibC::Int
  fun vfprintf = al_vfprintf(f : File, format : LibC::Char*, args : VaList) : LibC::Int
  fun fopen_fd = al_fopen_fd(fd : LibC::Int, mode : LibC::Char*) : File
  fun make_temp_file = al_make_temp_file(tmpl : LibC::Char*, ret_path : Path*) : File
  fun fopen_slice = al_fopen_slice(fp : File, initial_size : LibC::SizeT, mode : LibC::Char*) : File
  fun get_new_file_interface = al_get_new_file_interface : FileInterface*
  fun set_new_file_interface = al_set_new_file_interface(file_interface : FileInterface*)
  fun set_standard_file_interface = al_set_standard_file_interface
  fun get_file_userdata = al_get_file_userdata(f : File) : Void*
  KeepBitmapFormat     =    2_i64
  NoPremultipliedAlpha =  512_i64
  KeepIndex            = 2048_i64
  fun register_bitmap_loader = al_register_bitmap_loader(ext : LibC::Char*, loader : IioLoaderFunction) : LibC::Bool
  alias IioLoaderFunction = (LibC::Char*, LibC::Int -> Bitmap)
  fun register_bitmap_saver = al_register_bitmap_saver(ext : LibC::Char*, saver : IioSaverFunction) : LibC::Bool
  alias IioSaverFunction = (LibC::Char*, Bitmap -> LibC::Bool)
  fun register_bitmap_loader_f = al_register_bitmap_loader_f(ext : LibC::Char*, fs_loader : IioFsLoaderFunction) : LibC::Bool
  alias IioFsLoaderFunction = (File, LibC::Int -> Bitmap)
  fun register_bitmap_saver_f = al_register_bitmap_saver_f(ext : LibC::Char*, fs_saver : IioFsSaverFunction) : LibC::Bool
  alias IioFsSaverFunction = (File, Bitmap -> LibC::Bool)
  fun register_bitmap_identifier = al_register_bitmap_identifier(ext : LibC::Char*, identifier : IioIdentifierFunction) : LibC::Bool
  alias IioIdentifierFunction = (File -> LibC::Bool)
  fun load_bitmap = al_load_bitmap(filename : LibC::Char*) : Bitmap
  fun load_bitmap_flags = al_load_bitmap_flags(filename : LibC::Char*, flags : LibC::Int) : Bitmap
  fun load_bitmap_f = al_load_bitmap_f(fp : File, ident : LibC::Char*) : Bitmap
  fun load_bitmap_flags_f = al_load_bitmap_flags_f(fp : File, ident : LibC::Char*, flags : LibC::Int) : Bitmap
  fun save_bitmap = al_save_bitmap(filename : LibC::Char*, bitmap : Bitmap) : LibC::Bool
  fun save_bitmap_f = al_save_bitmap_f(fp : File, ident : LibC::Char*, bitmap : Bitmap) : LibC::Bool
  fun identify_bitmap_f = al_identify_bitmap_f(fp : File) : LibC::Char*
  fun identify_bitmap = al_identify_bitmap(filename : LibC::Char*) : LibC::Char*
  LockReadwrite = 0_i64
  LockReadonly = 1_i64
  LockWriteonly = 2_i64

  struct LockedRegion
    data : Void*
    format : LibC::Int
    pitch : LibC::Int
    pixel_size : LibC::Int
  end

  fun lock_bitmap = al_lock_bitmap(bitmap : Bitmap, format : LibC::Int, flags : LibC::Int) : LockedRegion*
  fun lock_bitmap_region = al_lock_bitmap_region(bitmap : Bitmap, x : LibC::Int, y : LibC::Int, width : LibC::Int, height : LibC::Int, format : LibC::Int, flags : LibC::Int) : LockedRegion*
  fun lock_bitmap_blocked = al_lock_bitmap_blocked(bitmap : Bitmap, flags : LibC::Int) : LockedRegion*
  fun lock_bitmap_region_blocked = al_lock_bitmap_region_blocked(bitmap : Bitmap, x_block : LibC::Int, y_block : LibC::Int, width_block : LibC::Int, height_block : LibC::Int, flags : LibC::Int) : LockedRegion*
  fun unlock_bitmap = al_unlock_bitmap(bitmap : Bitmap)
  fun is_bitmap_locked = al_is_bitmap_locked(bitmap : Bitmap) : LibC::Bool
  fun set_blender = al_set_blender(op : LibC::Int, source : LibC::Int, dest : LibC::Int)
  fun set_blend_color = al_set_blend_color(color : Color)
  fun get_blender = al_get_blender(op : LibC::Int*, source : LibC::Int*, dest : LibC::Int*)
  fun get_blend_color = al_get_blend_color : Color
  fun set_separate_blender = al_set_separate_blender(op : LibC::Int, source : LibC::Int, dest : LibC::Int, alpha_op : LibC::Int, alpha_source : LibC::Int, alpha_dest : LibC::Int)
  fun get_separate_blender = al_get_separate_blender(op : LibC::Int*, source : LibC::Int*, dest : LibC::Int*, alpha_op : LibC::Int*, alpha_src : LibC::Int*, alpha_dest : LibC::Int*)
  EventJoystickAxis          =  1_i64
  EventJoystickButtonDown    =  2_i64
  EventJoystickButtonUp      =  3_i64
  EventJoystickConfiguration =  4_i64
  EventKeyDown               = 10_i64
  EventKeyChar               = 11_i64
  EventKeyUp                 = 12_i64
  EventMouseAxes             = 20_i64
  EventMouseButtonDown       = 21_i64
  EventMouseButtonUp         = 22_i64
  EventMouseEnterDisplay     = 23_i64
  EventMouseLeaveDisplay     = 24_i64
  EventMouseWarped           = 25_i64
  EventTimer                 = 30_i64
  EventDisplayExpose         = 40_i64
  EventDisplayResize         = 41_i64
  EventDisplayClose          = 42_i64
  EventDisplayLost           = 43_i64
  EventDisplayFound          = 44_i64
  EventDisplaySwitchIn       = 45_i64
  EventDisplaySwitchOut      = 46_i64
  EventDisplayOrientation    = 47_i64
  EventDisplayHaltDrawing    = 48_i64
  EventDisplayResumeDrawing  = 49_i64
  EventTouchBegin            = 50_i64
  EventTouchEnd              = 51_i64
  EventTouchMove             = 52_i64
  EventTouchCancel           = 53_i64
  EventDisplayConnected      = 60_i64
  EventDisplayDisconnected   = 61_i64

  struct EventSource
    __pad : LibC::Int[32]
  end

  struct AnyEvent
    type : EventType
    source : EventSource*
    timestamp : LibC::Double
  end

  alias EventType = LibC::UInt

  struct DisplayEvent
    type : EventType
    source : Void*
    timestamp : LibC::Double
    x : LibC::Int
    y : LibC::Int
    width : LibC::Int
    height : LibC::Int
    orientation : LibC::Int
  end

  struct JoystickEvent
    type : EventType
    source : Void*
    timestamp : LibC::Double
    id : Void*
    stick : LibC::Int
    axis : LibC::Int
    pos : LibC::Float
    button : LibC::Int
  end

  struct KeyboardEvent
    type : EventType
    source : Void*
    timestamp : LibC::Double
    display : Void*
    keycode : LibC::Int
    unichar : LibC::Int
    modifiers : LibC::UInt
    repeat : LibC::Bool
  end

  struct MouseEvent
    type : EventType
    source : Void*
    timestamp : LibC::Double
    display : Void*
    x : LibC::Int
    y : LibC::Int
    z : LibC::Int
    w : LibC::Int
    dx : LibC::Int
    dy : LibC::Int
    dz : LibC::Int
    dw : LibC::Int
    button : LibC::UInt
    pressure : LibC::Float
  end

  struct TimerEvent
    type : EventType
    source : Void*
    timestamp : LibC::Double
    count : Int64T
    error : LibC::Double
  end

  struct TouchEvent
    type : EventType
    source : Void*
    timestamp : LibC::Double
    display : Void*
    id : LibC::Int
    x : LibC::Float
    y : LibC::Float
    dx : LibC::Float
    dy : LibC::Float
    primary : LibC::Bool
  end

  struct UserEvent
    type : EventType
    source : EventSource*
    timestamp : LibC::Double
    __internal__descr : Void*
    data1 : IntptrT
    data2 : IntptrT
    data3 : IntptrT
    data4 : IntptrT
  end

  alias X__DarwinIntptrT = LibC::Long
  alias IntptrT = X__DarwinIntptrT

  union Event
    type : EventType
    any : AnyEvent
    display : DisplayEvent
    joystick : JoystickEvent
    keyboard : KeyboardEvent
    mouse : MouseEvent
    timer : TimerEvent
    touch : TouchEvent
    user : UserEvent
  end

  fun init_user_event_source = al_init_user_event_source(x0 : EventSource*)
  fun destroy_user_event_source = al_destroy_user_event_source(x0 : EventSource*)
  fun emit_user_event = al_emit_user_event(x0 : EventSource*, x1 : Event*, dtor : (UserEvent* -> Void)) : LibC::Bool
  fun unref_user_event = al_unref_user_event(x0 : UserEvent*)
  fun set_event_source_data = al_set_event_source_data(x0 : EventSource*, data : IntptrT)
  fun get_event_source_data = al_get_event_source_data(x0 : EventSource*) : IntptrT
  fun create_event_queue = al_create_event_queue : EventQueue
  type EventQueue = Void*
  fun destroy_event_queue = al_destroy_event_queue(x0 : EventQueue)
  fun is_event_source_registered = al_is_event_source_registered(x0 : EventQueue, x1 : EventSource*) : LibC::Bool
  fun register_event_source = al_register_event_source(x0 : EventQueue, x1 : EventSource*)
  fun unregister_event_source = al_unregister_event_source(x0 : EventQueue, x1 : EventSource*)
  fun pause_event_queue = al_pause_event_queue(x0 : EventQueue, x1 : LibC::Bool)
  fun is_event_queue_paused = al_is_event_queue_paused(x0 : EventQueue) : LibC::Bool
  fun is_event_queue_empty = al_is_event_queue_empty(x0 : EventQueue) : LibC::Bool
  fun get_next_event = al_get_next_event(x0 : EventQueue, ret_event : Event*) : LibC::Bool
  fun peek_next_event = al_peek_next_event(x0 : EventQueue, ret_event : Event*) : LibC::Bool
  fun drop_next_event = al_drop_next_event(x0 : EventQueue) : LibC::Bool
  fun flush_event_queue = al_flush_event_queue(x0 : EventQueue)
  fun wait_for_event = al_wait_for_event(x0 : EventQueue, ret_event : Event*)
  fun wait_for_event_timed = al_wait_for_event_timed(x0 : EventQueue, ret_event : Event*, secs : LibC::Float) : LibC::Bool
  fun wait_for_event_until = al_wait_for_event_until(queue : EventQueue, ret_event : Event*, timeout : Timeout*) : LibC::Bool
  Windowed                =     1_i64
  Fullscreen              =     2_i64
  Opengl                  =     4_i64
  Direct3DInternal        =     8_i64
  Resizable               =    16_i64
  Frameless               =    32_i64
  Noframe                 =    32_i64
  GenerateExposeEvents    =    64_i64
  Opengl30                =   128_i64
  OpenglForwardCompatible =   256_i64
  FullscreenWindow        =   512_i64
  Minimized               =  1024_i64
  ProgrammablePipeline    =  2048_i64
  GtkToplevelInternal     =  4096_i64
  Maximized               =  8192_i64
  OpenglEsProfile         = 16384_i64
  Dontcare                =     0_i64
  Require                 =     1_i64
  Suggest                 =     2_i64
  X_PrimMaxUserAttr       =    10_i64
  fun set_new_display_refresh_rate = al_set_new_display_refresh_rate(refresh_rate : LibC::Int)
  fun set_new_display_flags = al_set_new_display_flags(flags : LibC::Int)
  fun get_new_display_refresh_rate = al_get_new_display_refresh_rate : LibC::Int
  fun get_new_display_flags = al_get_new_display_flags : LibC::Int
  fun set_new_window_title = al_set_new_window_title(title : LibC::Char*)
  fun get_new_window_title = al_get_new_window_title : LibC::Char*
  fun get_display_width = al_get_display_width(display : Display*) : LibC::Int
  fun get_display_height = al_get_display_height(display : Display*) : LibC::Int
  fun get_display_format = al_get_display_format(display : Display*) : LibC::Int
  fun get_display_refresh_rate = al_get_display_refresh_rate(display : Display*) : LibC::Int
  fun get_display_flags = al_get_display_flags(display : Display*) : LibC::Int
  fun get_display_orientation = al_get_display_orientation(display : Display*) : LibC::Int
  fun set_display_flag = al_set_display_flag(display : Display*, flag : LibC::Int, onoff : LibC::Bool) : LibC::Bool
  fun create_display = al_create_display(w : LibC::Int, h : LibC::Int) : Display*
  fun destroy_display = al_destroy_display(display : Display*)
  fun get_current_display = al_get_current_display : Display*
  fun set_target_bitmap = al_set_target_bitmap(bitmap : Bitmap)
  fun set_target_backbuffer = al_set_target_backbuffer(display : Display*)
  fun get_backbuffer = al_get_backbuffer(display : Display*) : Bitmap
  fun get_target_bitmap = al_get_target_bitmap : Bitmap
  fun acknowledge_resize = al_acknowledge_resize(display : Display*) : LibC::Bool
  fun resize_display = al_resize_display(display : Display*, width : LibC::Int, height : LibC::Int) : LibC::Bool
  fun flip_display = al_flip_display
  fun update_display_region = al_update_display_region(x : LibC::Int, y : LibC::Int, width : LibC::Int, height : LibC::Int)
  fun is_compatible_bitmap = al_is_compatible_bitmap(bitmap : Bitmap) : LibC::Bool
  fun wait_for_vsync = al_wait_for_vsync : LibC::Bool
  fun get_display_event_source = al_get_display_event_source(display : Display*) : EventSource*
  fun set_display_icon = al_set_display_icon(display : Display*, icon : Bitmap)
  fun set_display_icons = al_set_display_icons(display : Display*, num_icons : LibC::Int, icons : Bitmap*)
  fun get_new_display_adapter = al_get_new_display_adapter : LibC::Int
  fun set_new_display_adapter = al_set_new_display_adapter(adapter : LibC::Int)
  fun set_new_window_position = al_set_new_window_position(x : LibC::Int, y : LibC::Int)
  fun get_new_window_position = al_get_new_window_position(x : LibC::Int*, y : LibC::Int*)
  fun set_window_position = al_set_window_position(display : Display*, x : LibC::Int, y : LibC::Int)
  fun get_window_position = al_get_window_position(display : Display*, x : LibC::Int*, y : LibC::Int*)
  fun set_window_constraints = al_set_window_constraints(display : Display*, min_w : LibC::Int, min_h : LibC::Int, max_w : LibC::Int, max_h : LibC::Int) : LibC::Bool
  fun get_window_constraints = al_get_window_constraints(display : Display*, min_w : LibC::Int*, min_h : LibC::Int*, max_w : LibC::Int*, max_h : LibC::Int*) : LibC::Bool
  fun apply_window_constraints = al_apply_window_constraints(display : Display*, onoff : LibC::Bool)
  fun set_window_title = al_set_window_title(display : Display*, title : LibC::Char*)
  fun set_new_display_option = al_set_new_display_option(option : LibC::Int, value : LibC::Int, importance : LibC::Int)
  fun get_new_display_option = al_get_new_display_option(option : LibC::Int, importance : LibC::Int*) : LibC::Int
  fun reset_new_display_options = al_reset_new_display_options
  fun set_display_option = al_set_display_option(display : Display*, option : LibC::Int, value : LibC::Int)
  fun get_display_option = al_get_display_option(display : Display*, option : LibC::Int) : LibC::Int
  fun hold_bitmap_drawing = al_hold_bitmap_drawing(hold : LibC::Bool)
  fun is_bitmap_drawing_held = al_is_bitmap_drawing_held : LibC::Bool
  fun acknowledge_drawing_halt = al_acknowledge_drawing_halt(display : Display*)
  fun acknowledge_drawing_resume = al_acknowledge_drawing_resume(display : Display*)
  fun get_clipboard_text = al_get_clipboard_text(display : Display*) : LibC::Char*
  fun set_clipboard_text = al_set_clipboard_text(display : Display*, text : LibC::Char*) : LibC::Bool
  fun clipboard_has_text = al_clipboard_has_text(display : Display*) : LibC::Bool
  fun create_config = al_create_config : Config
  type Config = Void*
  fun add_config_section = al_add_config_section(config : Config, name : LibC::Char*)
  fun set_config_value = al_set_config_value(config : Config, section : LibC::Char*, key : LibC::Char*, value : LibC::Char*)
  fun add_config_comment = al_add_config_comment(config : Config, section : LibC::Char*, comment : LibC::Char*)
  fun get_config_value = al_get_config_value(config : Config, section : LibC::Char*, key : LibC::Char*) : LibC::Char*
  fun load_config_file = al_load_config_file(filename : LibC::Char*) : Config
  fun load_config_file_f = al_load_config_file_f(filename : File) : Config
  fun save_config_file = al_save_config_file(filename : LibC::Char*, config : Config) : LibC::Bool
  fun save_config_file_f = al_save_config_file_f(file : File, config : Config) : LibC::Bool
  fun merge_config_into = al_merge_config_into(master : Config, add : Config)
  fun merge_config = al_merge_config(cfg1 : Config, cfg2 : Config) : Config
  fun destroy_config = al_destroy_config(config : Config)
  fun remove_config_section = al_remove_config_section(config : Config, section : LibC::Char*) : LibC::Bool
  fun remove_config_key = al_remove_config_key(config : Config, section : LibC::Char*, key : LibC::Char*) : LibC::Bool
  fun get_first_config_section = al_get_first_config_section(config : Config, iterator : ConfigSection*) : LibC::Char*
  type ConfigSection = Void*
  fun get_next_config_section = al_get_next_config_section(iterator : ConfigSection*) : LibC::Char*
  fun get_first_config_entry = al_get_first_config_entry(config : Config, section : LibC::Char*, iterator : ConfigEntry*) : LibC::Char*
  type ConfigEntry = Void*
  fun get_next_config_entry = al_get_next_config_entry(iterator : ConfigEntry*) : LibC::Char*
  fun get_cpu_count = al_get_cpu_count : LibC::Int
  fun get_ram_size = al_get_ram_size : LibC::Int
  fun _trace_prefix = _al_trace_prefix(channel : LibC::Char*, level : LibC::Int, file : LibC::Char*, line : LibC::Int, function : LibC::Char*) : LibC::Bool
  fun _trace_suffix = _al_trace_suffix(msg : LibC::Char*, ...)
  fun register_assert_handler = al_register_assert_handler(handler : (LibC::Char*, LibC::Char*, LibC::Int, LibC::Char* -> Void))
  fun register_trace_handler = al_register_trace_handler(handler : (LibC::Char* -> Void))
  fun clear_to_color = al_clear_to_color(color : Color)
  fun clear_depth_buffer = al_clear_depth_buffer(x : LibC::Float)
  fun draw_pixel = al_draw_pixel(x : LibC::Float, y : LibC::Float, color : Color)
  fun get_errno = al_get_errno : LibC::Int
  fun set_errno = al_set_errno(errnum : LibC::Int)
  alias Fixed = Int32T
  fun fixsqrt = al_fixsqrt(x : Fixed) : Fixed
  fun fixhypot = al_fixhypot(x : Fixed, y : Fixed) : Fixed
  fun fixatan = al_fixatan(x : Fixed) : Fixed
  fun fixatan2 = al_fixatan2(y : Fixed, x : Fixed) : Fixed
  fun ftofix = al_ftofix(x : LibC::Double) : Fixed
  fun ftofix = al_ftofix(x : LibC::Double) : Fixed
  fun fixtof = al_fixtof(x : Fixed) : LibC::Double
  fun fixtof = al_fixtof(x : Fixed) : LibC::Double
  fun fixadd = al_fixadd(x : Fixed, y : Fixed) : Fixed
  fun fixadd = al_fixadd(x : Fixed, y : Fixed) : Fixed
  fun fixsub = al_fixsub(x : Fixed, y : Fixed) : Fixed
  fun fixsub = al_fixsub(x : Fixed, y : Fixed) : Fixed
  fun fixmul = al_fixmul(x : Fixed, y : Fixed) : Fixed
  fun fixmul = al_fixmul(x : Fixed, y : Fixed) : Fixed
  fun fixdiv = al_fixdiv(x : Fixed, y : Fixed) : Fixed
  fun fixdiv = al_fixdiv(x : Fixed, y : Fixed) : Fixed
  fun fixfloor = al_fixfloor(x : Fixed) : LibC::Int
  fun fixfloor = al_fixfloor(x : Fixed) : LibC::Int
  fun fixceil = al_fixceil(x : Fixed) : LibC::Int
  fun fixceil = al_fixceil(x : Fixed) : LibC::Int
  fun itofix = al_itofix(x : LibC::Int) : Fixed
  fun itofix = al_itofix(x : LibC::Int) : Fixed
  fun fixtoi = al_fixtoi(x : Fixed) : LibC::Int
  fun fixtoi = al_fixtoi(x : Fixed) : LibC::Int
  fun fixcos = al_fixcos(x : Fixed) : Fixed
  fun fixcos = al_fixcos(x : Fixed) : Fixed
  fun fixsin = al_fixsin(x : Fixed) : Fixed
  fun fixsin = al_fixsin(x : Fixed) : Fixed
  fun fixtan = al_fixtan(x : Fixed) : Fixed
  fun fixtan = al_fixtan(x : Fixed) : Fixed
  fun fixacos = al_fixacos(x : Fixed) : Fixed
  fun fixacos = al_fixacos(x : Fixed) : Fixed
  fun fixasin = al_fixasin(x : Fixed) : Fixed
  fun fixasin = al_fixasin(x : Fixed) : Fixed

  struct FsEntry
    vtable : FsInterface*
  end

  struct FsInterface
    fs_create_entry : (LibC::Char* -> FsEntry*)
    fs_destroy_entry : (FsEntry* -> Void)
    fs_entry_name : (FsEntry* -> LibC::Char*)
    fs_update_entry : (FsEntry* -> LibC::Bool)
    fs_entry_mode : (FsEntry* -> Uint32T)
    fs_entry_atime : (FsEntry* -> TimeT)
    fs_entry_mtime : (FsEntry* -> TimeT)
    fs_entry_ctime : (FsEntry* -> TimeT)
    fs_entry_size : (FsEntry* -> OffT)
    fs_entry_exists : (FsEntry* -> LibC::Bool)
    fs_remove_entry : (FsEntry* -> LibC::Bool)
    fs_open_directory : (FsEntry* -> LibC::Bool)
    fs_read_directory : (FsEntry* -> FsEntry*)
    fs_close_directory : (FsEntry* -> LibC::Bool)
    fs_filename_exists : (LibC::Char* -> LibC::Bool)
    fs_remove_filename : (LibC::Char* -> LibC::Bool)
    fs_get_current_directory : (-> LibC::Char*)
    fs_change_directory : (LibC::Char* -> LibC::Bool)
    fs_make_directory : (LibC::Char* -> LibC::Bool)
    fs_open_file : (FsEntry*, LibC::Char* -> File)
  end

  alias X__DarwinTimeT = LibC::Long
  alias TimeT = X__DarwinTimeT
  fun create_fs_entry = al_create_fs_entry(path : LibC::Char*) : FsEntry*
  fun destroy_fs_entry = al_destroy_fs_entry(e : FsEntry*)
  fun get_fs_entry_name = al_get_fs_entry_name(e : FsEntry*) : LibC::Char*
  fun update_fs_entry = al_update_fs_entry(e : FsEntry*) : LibC::Bool
  fun get_fs_entry_mode = al_get_fs_entry_mode(e : FsEntry*) : Uint32T
  fun get_fs_entry_atime = al_get_fs_entry_atime(e : FsEntry*) : TimeT
  fun get_fs_entry_mtime = al_get_fs_entry_mtime(e : FsEntry*) : TimeT
  fun get_fs_entry_ctime = al_get_fs_entry_ctime(e : FsEntry*) : TimeT
  fun get_fs_entry_size = al_get_fs_entry_size(e : FsEntry*) : OffT
  fun fs_entry_exists = al_fs_entry_exists(e : FsEntry*) : LibC::Bool
  fun remove_fs_entry = al_remove_fs_entry(e : FsEntry*) : LibC::Bool
  fun open_directory = al_open_directory(e : FsEntry*) : LibC::Bool
  fun read_directory = al_read_directory(e : FsEntry*) : FsEntry*
  fun close_directory = al_close_directory(e : FsEntry*) : LibC::Bool
  fun filename_exists = al_filename_exists(path : LibC::Char*) : LibC::Bool
  fun remove_filename = al_remove_filename(path : LibC::Char*) : LibC::Bool
  fun get_current_directory = al_get_current_directory : LibC::Char*
  fun change_directory = al_change_directory(path : LibC::Char*) : LibC::Bool
  fun make_directory = al_make_directory(path : LibC::Char*) : LibC::Bool
  fun open_fs_entry = al_open_fs_entry(e : FsEntry*, mode : LibC::Char*) : File
  fun for_each_fs_entry = al_for_each_fs_entry(dir : FsEntry*, callback : (FsEntry*, Void* -> LibC::Int), extra : Void*) : LibC::Int
  fun get_fs_interface = al_get_fs_interface : FsInterface*
  fun set_fs_interface = al_set_fs_interface(vtable : FsInterface*)
  fun set_standard_fs_interface = al_set_standard_fs_interface

  struct DisplayMode
    width : LibC::Int
    height : LibC::Int
    format : LibC::Int
    refresh_rate : LibC::Int
  end

  fun get_num_display_modes = al_get_num_display_modes : LibC::Int
  fun get_display_mode = al_get_display_mode(index : LibC::Int, mode : DisplayMode*) : DisplayMode*

  struct JoystickState
    stick : JoystickStateStick[16]
    button : LibC::Int[32]
  end

  struct JoystickStateStick
    axis : LibC::Float[3]
  end

  fun install_joystick = al_install_joystick : LibC::Bool
  fun uninstall_joystick = al_uninstall_joystick
  fun is_joystick_installed = al_is_joystick_installed : LibC::Bool
  fun reconfigure_joysticks = al_reconfigure_joysticks : LibC::Bool
  fun get_num_joysticks = al_get_num_joysticks : LibC::Int
  fun get_joystick = al_get_joystick(joyn : LibC::Int) : Joystick*
  fun release_joystick = al_release_joystick(x0 : Joystick*)
  fun get_joystick_active = al_get_joystick_active(x0 : Joystick*) : LibC::Bool
  fun get_joystick_name = al_get_joystick_name(x0 : Joystick*) : LibC::Char*
  fun get_joystick_num_sticks = al_get_joystick_num_sticks(x0 : Joystick*) : LibC::Int
  fun get_joystick_stick_flags = al_get_joystick_stick_flags(x0 : Joystick*, stick : LibC::Int) : LibC::Int
  fun get_joystick_stick_name = al_get_joystick_stick_name(x0 : Joystick*, stick : LibC::Int) : LibC::Char*
  fun get_joystick_num_axes = al_get_joystick_num_axes(x0 : Joystick*, stick : LibC::Int) : LibC::Int
  fun get_joystick_axis_name = al_get_joystick_axis_name(x0 : Joystick*, stick : LibC::Int, axis : LibC::Int) : LibC::Char*
  fun get_joystick_num_buttons = al_get_joystick_num_buttons(x0 : Joystick*) : LibC::Int
  fun get_joystick_button_name = al_get_joystick_button_name(x0 : Joystick*, buttonn : LibC::Int) : LibC::Char*
  fun get_joystick_state = al_get_joystick_state(x0 : Joystick*, ret_state : JoystickState*)
  fun get_joystick_event_source = al_get_joystick_event_source : EventSource*
  KeyA             =     1_i64
  KeyB             =     2_i64
  KeyC             =     3_i64
  KeyD             =     4_i64
  KeyE             =     5_i64
  KeyF             =     6_i64
  KeyG             =     7_i64
  KeyH             =     8_i64
  KeyI             =     9_i64
  KeyJ             =    10_i64
  KeyK             =    11_i64
  KeyL             =    12_i64
  KeyM             =    13_i64
  KeyN             =    14_i64
  KeyO             =    15_i64
  KeyP             =    16_i64
  KeyQ             =    17_i64
  KeyR             =    18_i64
  KeyS             =    19_i64
  KeyT             =    20_i64
  KeyU             =    21_i64
  KeyV             =    22_i64
  KeyW             =    23_i64
  KeyX             =    24_i64
  KeyY             =    25_i64
  KeyZ             =    26_i64
  Key0             =    27_i64
  Key1             =    28_i64
  Key2             =    29_i64
  Key3             =    30_i64
  Key4             =    31_i64
  Key5             =    32_i64
  Key6             =    33_i64
  Key7             =    34_i64
  Key8             =    35_i64
  Key9             =    36_i64
  KeyPad0          =    37_i64
  KeyPad1          =    38_i64
  KeyPad2          =    39_i64
  KeyPad3          =    40_i64
  KeyPad4          =    41_i64
  KeyPad5          =    42_i64
  KeyPad6          =    43_i64
  KeyPad7          =    44_i64
  KeyPad8          =    45_i64
  KeyPad9          =    46_i64
  KeyF1            =    47_i64
  KeyF2            =    48_i64
  KeyF3            =    49_i64
  KeyF4            =    50_i64
  KeyF5            =    51_i64
  KeyF6            =    52_i64
  KeyF7            =    53_i64
  KeyF8            =    54_i64
  KeyF9            =    55_i64
  KeyF10           =    56_i64
  KeyF11           =    57_i64
  KeyF12           =    58_i64
  KeyEscape        =    59_i64
  KeyTilde         =    60_i64
  KeyMinus         =    61_i64
  KeyEquals        =    62_i64
  KeyBackspace     =    63_i64
  KeyTab           =    64_i64
  KeyOpenbrace     =    65_i64
  KeyClosebrace    =    66_i64
  KeyEnter         =    67_i64
  KeySemicolon     =    68_i64
  KeyQuote         =    69_i64
  KeyBackslash     =    70_i64
  KeyBackslash2    =    71_i64
  KeyComma         =    72_i64
  KeyFullstop      =    73_i64
  KeySlash         =    74_i64
  KeySpace         =    75_i64
  KeyInsert        =    76_i64
  KeyDelete        =    77_i64
  KeyHome          =    78_i64
  KeyEnd           =    79_i64
  KeyPgup          =    80_i64
  KeyPgdn          =    81_i64
  KeyLeft          =    82_i64
  KeyRight         =    83_i64
  KeyUp            =    84_i64
  KeyDown          =    85_i64
  KeyPadSlash      =    86_i64
  KeyPadAsterisk   =    87_i64
  KeyPadMinus      =    88_i64
  KeyPadPlus       =    89_i64
  KeyPadDelete     =    90_i64
  KeyPadEnter      =    91_i64
  KeyPrintscreen   =    92_i64
  KeyPause         =    93_i64
  KeyAbntC1        =    94_i64
  KeyYen           =    95_i64
  KeyKana          =    96_i64
  KeyConvert       =    97_i64
  KeyNoconvert     =    98_i64
  KeyAt            =    99_i64
  KeyCircumflex    =   100_i64
  KeyColon2        =   101_i64
  KeyKanji         =   102_i64
  KeyPadEquals     =   103_i64
  KeyBackquote     =   104_i64
  KeySemicolon2    =   105_i64
  KeyCommand       =   106_i64
  KeyBack          =   107_i64
  KeyVolumeUp      =   108_i64
  KeyVolumeDown    =   109_i64
  KeySearch        =   110_i64
  KeyDpadCenter    =   111_i64
  KeyButtonX       =   112_i64
  KeyButtonY       =   113_i64
  KeyDpadUp        =   114_i64
  KeyDpadDown      =   115_i64
  KeyDpadLeft      =   116_i64
  KeyDpadRight     =   117_i64
  KeySelect        =   118_i64
  KeyStart         =   119_i64
  KeyButtonL1      =   120_i64
  KeyButtonR1      =   121_i64
  KeyButtonL2      =   122_i64
  KeyButtonR2      =   123_i64
  KeyButtonA       =   124_i64
  KeyButtonB       =   125_i64
  KeyThumbl        =   126_i64
  KeyThumbr        =   127_i64
  KeyUnknown       =   128_i64
  KeyModifiers     =   215_i64
  KeyLshift        =   215_i64
  KeyRshift        =   216_i64
  KeyLctrl         =   217_i64
  KeyRctrl         =   218_i64
  KeyAlt           =   219_i64
  KeyAltgr         =   220_i64
  KeyLwin          =   221_i64
  KeyRwin          =   222_i64
  KeyMenu          =   223_i64
  KeyScrolllock    =   224_i64
  KeyNumlock       =   225_i64
  KeyCapslock      =   226_i64
  KeyMax           =   227_i64
  KeymodShift      =     1_i64
  KeymodCtrl       =     2_i64
  KeymodAlt        =     4_i64
  KeymodLwin       =     8_i64
  KeymodRwin       =    16_i64
  KeymodMenu       =    32_i64
  KeymodAltgr      =    64_i64
  KeymodCommand    =   128_i64
  KeymodScrolllock =   256_i64
  KeymodNumlock    =   512_i64
  KeymodCapslock   =  1024_i64
  KeymodInaltseq   =  2048_i64
  KeymodAccent1    =  4096_i64
  KeymodAccent2    =  8192_i64
  KeymodAccent3    = 16384_i64
  KeymodAccent4    = 32768_i64

  struct KeyboardState
    display : Void*
    __key_down__internal__ : LibC::UInt[8]
  end

  fun is_keyboard_installed = al_is_keyboard_installed : LibC::Bool
  fun install_keyboard = al_install_keyboard : LibC::Bool
  fun uninstall_keyboard = al_uninstall_keyboard
  fun set_keyboard_leds = al_set_keyboard_leds(leds : LibC::Int) : LibC::Bool
  fun keycode_to_name = al_keycode_to_name(keycode : LibC::Int) : LibC::Char*
  fun get_keyboard_state = al_get_keyboard_state(ret_state : KeyboardState*)
  fun key_down = al_key_down(x0 : KeyboardState*, keycode : LibC::Int) : LibC::Bool
  fun get_keyboard_event_source = al_get_keyboard_event_source : EventSource*

  struct MouseState
    x : LibC::Int
    y : LibC::Int
    z : LibC::Int
    w : LibC::Int
    more_axes : LibC::Int[4]
    buttons : LibC::Int
    pressure : LibC::Float
    display : Void*
  end

  fun is_mouse_installed = al_is_mouse_installed : LibC::Bool
  fun install_mouse = al_install_mouse : LibC::Bool
  fun uninstall_mouse = al_uninstall_mouse
  fun get_mouse_num_buttons = al_get_mouse_num_buttons : LibC::UInt
  fun get_mouse_num_axes = al_get_mouse_num_axes : LibC::UInt
  fun set_mouse_xy = al_set_mouse_xy(display : Void*, x : LibC::Int, y : LibC::Int) : LibC::Bool
  fun set_mouse_z = al_set_mouse_z(z : LibC::Int) : LibC::Bool
  fun set_mouse_w = al_set_mouse_w(w : LibC::Int) : LibC::Bool
  fun set_mouse_axis = al_set_mouse_axis(axis : LibC::Int, value : LibC::Int) : LibC::Bool
  fun get_mouse_state = al_get_mouse_state(ret_state : MouseState*)
  fun mouse_button_down = al_mouse_button_down(state : MouseState*, button : LibC::Int) : LibC::Bool
  fun get_mouse_state_axis = al_get_mouse_state_axis(state : MouseState*, axis : LibC::Int) : LibC::Int
  fun get_mouse_cursor_position = al_get_mouse_cursor_position(ret_x : LibC::Int*, ret_y : LibC::Int*) : LibC::Bool
  fun grab_mouse = al_grab_mouse(display : Void*) : LibC::Bool
  fun ungrab_mouse = al_ungrab_mouse : LibC::Bool
  fun set_mouse_wheel_precision = al_set_mouse_wheel_precision(precision : LibC::Int)
  fun get_mouse_wheel_precision = al_get_mouse_wheel_precision : LibC::Int
  fun get_mouse_event_source = al_get_mouse_event_source : EventSource*

  struct TouchInputState
    touches : TouchState[16]
  end

  struct TouchState
    id : LibC::Int
    x : LibC::Float
    y : LibC::Float
    dx : LibC::Float
    dy : LibC::Float
    primary : LibC::Bool
    display : Void*
  end

  fun is_touch_input_installed = al_is_touch_input_installed : LibC::Bool
  fun install_touch_input = al_install_touch_input : LibC::Bool
  fun uninstall_touch_input = al_uninstall_touch_input
  fun get_touch_input_state = al_get_touch_input_state(ret_state : TouchInputState*)
  fun get_touch_input_event_source = al_get_touch_input_event_source : EventSource*

  struct MemoryInterface
    mi_malloc : (LibC::SizeT, LibC::Int, LibC::Char*, LibC::Char* -> Void*)
    mi_free : (Void*, LibC::Int, LibC::Char*, LibC::Char* -> Void)
    mi_realloc : (Void*, LibC::SizeT, LibC::Int, LibC::Char*, LibC::Char* -> Void*)
    mi_calloc : (LibC::SizeT, LibC::SizeT, LibC::Int, LibC::Char*, LibC::Char* -> Void*)
  end

  fun set_memory_interface = al_set_memory_interface(iface : MemoryInterface*)
  fun malloc_with_context = al_malloc_with_context(n : LibC::SizeT, line : LibC::Int, file : LibC::Char*, func : LibC::Char*) : Void*
  fun free_with_context = al_free_with_context(ptr : Void*, line : LibC::Int, file : LibC::Char*, func : LibC::Char*)
  fun realloc_with_context = al_realloc_with_context(ptr : Void*, n : LibC::SizeT, line : LibC::Int, file : LibC::Char*, func : LibC::Char*) : Void*
  fun calloc_with_context = al_calloc_with_context(count : LibC::SizeT, n : LibC::SizeT, line : LibC::Int, file : LibC::Char*, func : LibC::Char*) : Void*

  struct MonitorInfo
    x1 : LibC::Int
    y1 : LibC::Int
    x2 : LibC::Int
    y2 : LibC::Int
  end

  DefaultDisplayAdapter = -1_i64
  fun get_num_video_adapters = al_get_num_video_adapters : LibC::Int
  fun get_monitor_info = al_get_monitor_info(adapter : LibC::Int, info : MonitorInfo*) : LibC::Bool
  fun create_mouse_cursor = al_create_mouse_cursor(sprite : Bitmap*, xfocus : LibC::Int, yfocus : LibC::Int) : MouseCursor
  type MouseCursor = Void*
  fun destroy_mouse_cursor = al_destroy_mouse_cursor(x0 : MouseCursor)
  fun set_mouse_cursor = al_set_mouse_cursor(display : Display*, cursor : MouseCursor) : LibC::Bool
  fun set_system_mouse_cursor = al_set_system_mouse_cursor(display : Display*, cursor_id : SystemMouseCursor) : LibC::Bool
  enum SystemMouseCursor
    SystemMouseCursorNone        =  0
    SystemMouseCursorDefault     =  1
    SystemMouseCursorArrow       =  2
    SystemMouseCursorBusy        =  3
    SystemMouseCursorQuestion    =  4
    SystemMouseCursorEdit        =  5
    SystemMouseCursorMove        =  6
    SystemMouseCursorResizeN     =  7
    SystemMouseCursorResizeW     =  8
    SystemMouseCursorResizeS     =  9
    SystemMouseCursorResizeE     = 10
    SystemMouseCursorResizeNw    = 11
    SystemMouseCursorResizeSw    = 12
    SystemMouseCursorResizeSe    = 13
    SystemMouseCursorResizeNe    = 14
    SystemMouseCursorProgress    = 15
    SystemMouseCursorPrecision   = 16
    SystemMouseCursorLink        = 17
    SystemMouseCursorAltSelect   = 18
    SystemMouseCursorUnavailable = 19
    NumSystemMouseCursors        = 20
  end
  fun show_mouse_cursor = al_show_mouse_cursor(display : Display*) : LibC::Bool
  fun hide_mouse_cursor = al_hide_mouse_cursor(display : Display*) : LibC::Bool
  fun set_render_state = al_set_render_state(state : RenderState, value : LibC::Int)
  enum RenderState
    AlphaTest      = 16
    WriteMask      = 17
    DepthTest      = 18
    DepthFunction  = 19
    AlphaFunction  = 20
    AlphaTestValue = 21
  end

  struct Transform
    m : LibC::Float[4][4]
  end

  fun use_transform = al_use_transform(trans : Transform*)
  fun use_projection_transform = al_use_projection_transform(trans : Transform*)
  fun copy_transform = al_copy_transform(dest : Transform*, src : Transform*)
  fun identity_transform = al_identity_transform(trans : Transform*)
  fun build_transform = al_build_transform(trans : Transform*, x : LibC::Float, y : LibC::Float, sx : LibC::Float, sy : LibC::Float, theta : LibC::Float)
  fun build_camera_transform = al_build_camera_transform(trans : Transform*, position_x : LibC::Float, position_y : LibC::Float, position_z : LibC::Float, look_x : LibC::Float, look_y : LibC::Float, look_z : LibC::Float, up_x : LibC::Float, up_y : LibC::Float, up_z : LibC::Float)
  fun translate_transform = al_translate_transform(trans : Transform*, x : LibC::Float, y : LibC::Float)
  fun translate_transform_3d = al_translate_transform_3d(trans : Transform*, x : LibC::Float, y : LibC::Float, z : LibC::Float)
  fun rotate_transform = al_rotate_transform(trans : Transform*, theta : LibC::Float)
  fun rotate_transform_3d = al_rotate_transform_3d(trans : Transform*, x : LibC::Float, y : LibC::Float, z : LibC::Float, angle : LibC::Float)
  fun scale_transform = al_scale_transform(trans : Transform*, sx : LibC::Float, sy : LibC::Float)
  fun scale_transform_3d = al_scale_transform_3d(trans : Transform*, sx : LibC::Float, sy : LibC::Float, sz : LibC::Float)
  fun transform_coordinates = al_transform_coordinates(trans : Transform*, x : LibC::Float*, y : LibC::Float*)
  fun transform_coordinates_3d = al_transform_coordinates_3d(trans : Transform*, x : LibC::Float*, y : LibC::Float*, z : LibC::Float*)
  fun transform_coordinates_4d = al_transform_coordinates_4d(trans : Transform*, x : LibC::Float*, y : LibC::Float*, z : LibC::Float*, w : LibC::Float*)
  fun transform_coordinates_3d_projective = al_transform_coordinates_3d_projective(trans : Transform*, x : LibC::Float*, y : LibC::Float*, z : LibC::Float*)
  fun compose_transform = al_compose_transform(trans : Transform*, other : Transform*)
  fun get_current_transform = al_get_current_transform : Transform*
  fun get_current_inverse_transform = al_get_current_inverse_transform : Transform*
  fun get_current_projection_transform = al_get_current_projection_transform : Transform*
  fun invert_transform = al_invert_transform(trans : Transform*)
  fun check_inverse = al_check_inverse(trans : Transform*, tol : LibC::Float) : LibC::Int
  fun orthographic_transform = al_orthographic_transform(trans : Transform*, left : LibC::Float, top : LibC::Float, n : LibC::Float, right : LibC::Float, bottom : LibC::Float, f : LibC::Float)
  fun perspective_transform = al_perspective_transform(trans : Transform*, left : LibC::Float, top : LibC::Float, n : LibC::Float, right : LibC::Float, bottom : LibC::Float, f : LibC::Float)
  fun horizontal_shear_transform = al_horizontal_shear_transform(trans : Transform*, theta : LibC::Float)
  fun vertical_shear_transform = al_vertical_shear_transform(trans : Transform*, theta : LibC::Float)
  fun create_shader = al_create_shader(platform : ShaderPlatform) : Shader
  enum ShaderPlatform
    ShaderAuto = 0
    ShaderGlsl = 1
    ShaderHlsl = 2
  end
  type Shader = Void*
  fun attach_shader_source = al_attach_shader_source(shader : Shader, type : ShaderType, source : LibC::Char*) : LibC::Bool
  enum ShaderType
    VertexShader = 1
    PixelShader  = 2
  end
  fun attach_shader_source_file = al_attach_shader_source_file(shader : Shader, type : ShaderType, filename : LibC::Char*) : LibC::Bool
  fun build_shader = al_build_shader(shader : Shader) : LibC::Bool
  fun get_shader_log = al_get_shader_log(shader : Shader) : LibC::Char*
  fun get_shader_platform = al_get_shader_platform(shader : Shader) : ShaderPlatform
  fun use_shader = al_use_shader(shader : Shader) : LibC::Bool
  fun destroy_shader = al_destroy_shader(shader : Shader)
  fun set_shader_sampler = al_set_shader_sampler(name : LibC::Char*, bitmap : Bitmap, unit : LibC::Int) : LibC::Bool
  fun set_shader_matrix = al_set_shader_matrix(name : LibC::Char*, matrix : Transform*) : LibC::Bool
  fun set_shader_int = al_set_shader_int(name : LibC::Char*, i : LibC::Int) : LibC::Bool
  fun set_shader_float = al_set_shader_float(name : LibC::Char*, f : LibC::Float) : LibC::Bool
  fun set_shader_int_vector = al_set_shader_int_vector(name : LibC::Char*, num_components : LibC::Int, i : LibC::Int*, num_elems : LibC::Int) : LibC::Bool
  fun set_shader_float_vector = al_set_shader_float_vector(name : LibC::Char*, num_components : LibC::Int, f : LibC::Float*, num_elems : LibC::Int) : LibC::Bool
  fun set_shader_bool = al_set_shader_bool(name : LibC::Char*, b : LibC::Bool) : LibC::Bool
  fun get_default_shader_source = al_get_default_shader_source(platform : ShaderPlatform, type : ShaderType) : LibC::Char*
  fun install_system = al_install_system(version : LibC::Int, atexit_ptr : ((-> Void) -> LibC::Int)) : LibC::Bool
  fun uninstall_system = al_uninstall_system
  fun is_system_installed = al_is_system_installed : LibC::Bool
  fun get_system_driver = al_get_system_driver : System
  type System = Void*
  fun get_system_config = al_get_system_config : Config
  ResourcesPath     = 0_i64
  TempPath          = 1_i64
  UserDataPath      = 2_i64
  UserHomePath      = 3_i64
  UserSettingsPath  = 4_i64
  UserDocumentsPath = 5_i64
  ExenamePath       = 6_i64
  LastPath          = 7_i64
  fun get_standard_path = al_get_standard_path(id : LibC::Int) : Path
  fun set_exe_name = al_set_exe_name(path : LibC::Char*)
  fun set_org_name = al_set_org_name(org_name : LibC::Char*)
  fun set_app_name = al_set_app_name(app_name : LibC::Char*)
  fun get_org_name = al_get_org_name : LibC::Char*
  fun get_app_name = al_get_app_name : LibC::Char*
  fun inhibit_screensaver = al_inhibit_screensaver(inhibit : LibC::Bool) : LibC::Bool
  fun create_thread = al_create_thread(proc : (Thread, Void* -> Void*), arg : Void*) : Thread
  type Thread = Void*
  fun start_thread = al_start_thread(outer : Thread)
  fun join_thread = al_join_thread(outer : Thread, ret_value : Void**)
  fun set_thread_should_stop = al_set_thread_should_stop(outer : Thread)
  fun get_thread_should_stop = al_get_thread_should_stop(outer : Thread) : LibC::Bool
  fun destroy_thread = al_destroy_thread(thread : Thread)
  fun run_detached_thread = al_run_detached_thread(proc : (Void* -> Void*), arg : Void*)
  fun create_mutex = al_create_mutex : Mutex
  type Mutex = Void*
  fun create_mutex_recursive = al_create_mutex_recursive : Mutex
  fun lock_mutex = al_lock_mutex(mutex : Mutex)
  fun unlock_mutex = al_unlock_mutex(mutex : Mutex)
  fun destroy_mutex = al_destroy_mutex(mutex : Mutex)
  fun create_cond = al_create_cond : Cond
  type Cond = Void*
  fun destroy_cond = al_destroy_cond(cond : Cond)
  fun wait_cond = al_wait_cond(cond : Cond, mutex : Mutex)
  fun wait_cond_until = al_wait_cond_until(cond : Cond, mutex : Mutex, timeout : Timeout*) : LibC::Int
  fun broadcast_cond = al_broadcast_cond(cond : Cond)
  fun signal_cond = al_signal_cond(cond : Cond)
  fun create_timer = al_create_timer(speed_secs : LibC::Double) : Timer*
  fun destroy_timer = al_destroy_timer(timer : Timer*)
  fun start_timer = al_start_timer(timer : Timer*)
  fun stop_timer = al_stop_timer(timer : Timer*)
  fun resume_timer = al_resume_timer(timer : Timer*)
  fun get_timer_started = al_get_timer_started(timer : Timer*) : LibC::Bool
  fun get_timer_speed = al_get_timer_speed(timer : Timer*) : LibC::Double
  fun set_timer_speed = al_set_timer_speed(timer : Timer*, speed_secs : LibC::Double)
  fun get_timer_count = al_get_timer_count(timer : Timer*) : Int64T
  fun set_timer_count = al_set_timer_count(timer : Timer*, count : Int64T)
  fun add_timer_count = al_add_timer_count(timer : Timer*, diff : Int64T)
  fun get_timer_event_source = al_get_timer_event_source(timer : Timer*) : EventSource*

  struct State
    _tls : LibC::Char[1024]
  end

  fun store_state = al_store_state(state : State*, flags : LibC::Int)
  fun restore_state = al_restore_state(state : State*)
  fun _osx_get_path = _al_osx_get_path(id : LibC::Int) : Path

  struct SampleId
    _index : LibC::Int
    _id : LibC::Int
  end

  fun create_sample = al_create_sample(buf : Void*, samples : LibC::UInt, freq : LibC::UInt, depth : AudioDepth, chan_conf : ChannelConf, free_buf : LibC::Bool) : Sample
  enum AudioDepth
    AudioDepthInt8     =  0
    AudioDepthInt16    =  1
    AudioDepthInt24    =  2
    AudioDepthFloat32  =  3
    AudioDepthUnsigned =  8
    AudioDepthUint8    =  8
    AudioDepthUint16   =  9
    AudioDepthUint24   = 10
  end
  enum ChannelConf
    ChannelConf1  =  16
    ChannelConf2  =  32
    ChannelConf3  =  48
    ChannelConf4  =  64
    ChannelConf51 =  81
    ChannelConf61 =  97
    ChannelConf71 = 113
  end
  type Sample = Void*
  fun destroy_sample = al_destroy_sample(spl : Sample)
  fun create_sample_instance = al_create_sample_instance(data : Sample) : SampleInstance
  type SampleInstance = Void*
  fun destroy_sample_instance = al_destroy_sample_instance(spl : SampleInstance)
  fun get_sample_frequency = al_get_sample_frequency(spl : Sample) : LibC::UInt
  fun get_sample_length = al_get_sample_length(spl : Sample) : LibC::UInt
  fun get_sample_depth = al_get_sample_depth(spl : Sample) : AudioDepth
  fun get_sample_channels = al_get_sample_channels(spl : Sample) : ChannelConf
  fun get_sample_data = al_get_sample_data(spl : Sample) : Void*
  fun get_sample_instance_frequency = al_get_sample_instance_frequency(spl : SampleInstance) : LibC::UInt
  fun get_sample_instance_length = al_get_sample_instance_length(spl : SampleInstance) : LibC::UInt
  fun get_sample_instance_position = al_get_sample_instance_position(spl : SampleInstance) : LibC::UInt
  fun get_sample_instance_speed = al_get_sample_instance_speed(spl : SampleInstance) : LibC::Float
  fun get_sample_instance_gain = al_get_sample_instance_gain(spl : SampleInstance) : LibC::Float
  fun get_sample_instance_pan = al_get_sample_instance_pan(spl : SampleInstance) : LibC::Float
  fun get_sample_instance_time = al_get_sample_instance_time(spl : SampleInstance) : LibC::Float
  fun get_sample_instance_depth = al_get_sample_instance_depth(spl : SampleInstance) : AudioDepth
  fun get_sample_instance_channels = al_get_sample_instance_channels(spl : SampleInstance) : ChannelConf
  fun get_sample_instance_playmode = al_get_sample_instance_playmode(spl : SampleInstance) : Playmode
  enum Playmode
    PlaymodeOnce           = 256
    PlaymodeLoop           = 257
    PlaymodeBidir          = 258
    X_PlaymodeStreamOnce   = 259
    X_PlaymodeStreamOnedir = 260
  end
  fun get_sample_instance_playing = al_get_sample_instance_playing(spl : SampleInstance) : LibC::Bool
  fun get_sample_instance_attached = al_get_sample_instance_attached(spl : SampleInstance) : LibC::Bool
  fun set_sample_instance_position = al_set_sample_instance_position(spl : SampleInstance, val : LibC::UInt) : LibC::Bool
  fun set_sample_instance_length = al_set_sample_instance_length(spl : SampleInstance, val : LibC::UInt) : LibC::Bool
  fun set_sample_instance_speed = al_set_sample_instance_speed(spl : SampleInstance, val : LibC::Float) : LibC::Bool
  fun set_sample_instance_gain = al_set_sample_instance_gain(spl : SampleInstance, val : LibC::Float) : LibC::Bool
  fun set_sample_instance_pan = al_set_sample_instance_pan(spl : SampleInstance, val : LibC::Float) : LibC::Bool
  fun set_sample_instance_playmode = al_set_sample_instance_playmode(spl : SampleInstance, val : Playmode) : LibC::Bool
  fun set_sample_instance_playing = al_set_sample_instance_playing(spl : SampleInstance, val : LibC::Bool) : LibC::Bool
  fun detach_sample_instance = al_detach_sample_instance(spl : SampleInstance) : LibC::Bool
  fun set_sample = al_set_sample(spl : SampleInstance, data : Sample) : LibC::Bool
  fun get_sample = al_get_sample(spl : SampleInstance) : Sample
  fun play_sample_instance = al_play_sample_instance(spl : SampleInstance) : LibC::Bool
  fun stop_sample_instance = al_stop_sample_instance(spl : SampleInstance) : LibC::Bool
  fun create_audio_stream = al_create_audio_stream(buffer_count : LibC::SizeT, samples : LibC::UInt, freq : LibC::UInt, depth : AudioDepth, chan_conf : ChannelConf) : AudioStream
  type AudioStream = Void*
  fun destroy_audio_stream = al_destroy_audio_stream(stream : AudioStream)
  fun drain_audio_stream = al_drain_audio_stream(stream : AudioStream)
  fun get_audio_stream_frequency = al_get_audio_stream_frequency(stream : AudioStream) : LibC::UInt
  fun get_audio_stream_length = al_get_audio_stream_length(stream : AudioStream) : LibC::UInt
  fun get_audio_stream_fragments = al_get_audio_stream_fragments(stream : AudioStream) : LibC::UInt
  fun get_available_audio_stream_fragments = al_get_available_audio_stream_fragments(stream : AudioStream) : LibC::UInt
  fun get_audio_stream_speed = al_get_audio_stream_speed(stream : AudioStream) : LibC::Float
  fun get_audio_stream_gain = al_get_audio_stream_gain(stream : AudioStream) : LibC::Float
  fun get_audio_stream_pan = al_get_audio_stream_pan(stream : AudioStream) : LibC::Float
  fun get_audio_stream_channels = al_get_audio_stream_channels(stream : AudioStream) : ChannelConf
  fun get_audio_stream_depth = al_get_audio_stream_depth(stream : AudioStream) : AudioDepth
  fun get_audio_stream_playmode = al_get_audio_stream_playmode(stream : AudioStream) : Playmode
  fun get_audio_stream_playing = al_get_audio_stream_playing(spl : AudioStream) : LibC::Bool
  fun get_audio_stream_attached = al_get_audio_stream_attached(spl : AudioStream) : LibC::Bool
  fun get_audio_stream_played_samples = al_get_audio_stream_played_samples(stream : AudioStream) : Uint64T
  fun get_audio_stream_fragment = al_get_audio_stream_fragment(stream : AudioStream) : Void*
  fun set_audio_stream_speed = al_set_audio_stream_speed(stream : AudioStream, val : LibC::Float) : LibC::Bool
  fun set_audio_stream_gain = al_set_audio_stream_gain(stream : AudioStream, val : LibC::Float) : LibC::Bool
  fun set_audio_stream_pan = al_set_audio_stream_pan(stream : AudioStream, val : LibC::Float) : LibC::Bool
  fun set_audio_stream_playmode = al_set_audio_stream_playmode(stream : AudioStream, val : Playmode) : LibC::Bool
  fun set_audio_stream_playing = al_set_audio_stream_playing(stream : AudioStream, val : LibC::Bool) : LibC::Bool
  fun detach_audio_stream = al_detach_audio_stream(stream : AudioStream) : LibC::Bool
  fun set_audio_stream_fragment = al_set_audio_stream_fragment(stream : AudioStream, val : Void*) : LibC::Bool
  fun rewind_audio_stream = al_rewind_audio_stream(stream : AudioStream) : LibC::Bool
  fun seek_audio_stream_secs = al_seek_audio_stream_secs(stream : AudioStream, time : LibC::Double) : LibC::Bool
  fun get_audio_stream_position_secs = al_get_audio_stream_position_secs(stream : AudioStream) : LibC::Double
  fun get_audio_stream_length_secs = al_get_audio_stream_length_secs(stream : AudioStream) : LibC::Double
  fun set_audio_stream_loop_secs = al_set_audio_stream_loop_secs(stream : AudioStream, start : LibC::Double, _end : LibC::Double) : LibC::Bool
  fun get_audio_stream_event_source = al_get_audio_stream_event_source(stream : AudioStream) : EventSource*
  fun create_mixer = al_create_mixer(freq : LibC::UInt, depth : AudioDepth, chan_conf : ChannelConf) : Mixer
  type Mixer = Void*
  fun destroy_mixer = al_destroy_mixer(mixer : Mixer)
  fun attach_sample_instance_to_mixer = al_attach_sample_instance_to_mixer(stream : SampleInstance, mixer : Mixer) : LibC::Bool
  fun attach_audio_stream_to_mixer = al_attach_audio_stream_to_mixer(stream : AudioStream, mixer : Mixer) : LibC::Bool
  fun attach_mixer_to_mixer = al_attach_mixer_to_mixer(stream : Mixer, mixer : Mixer) : LibC::Bool
  fun set_mixer_postprocess_callback = al_set_mixer_postprocess_callback(mixer : Mixer, cb : (Void*, LibC::UInt, Void* -> Void), data : Void*) : LibC::Bool
  fun get_mixer_frequency = al_get_mixer_frequency(mixer : Mixer) : LibC::UInt
  fun get_mixer_channels = al_get_mixer_channels(mixer : Mixer) : ChannelConf
  fun get_mixer_depth = al_get_mixer_depth(mixer : Mixer) : AudioDepth
  fun get_mixer_quality = al_get_mixer_quality(mixer : Mixer) : MixerQuality
  enum MixerQuality
    MixerQualityPoint  = 272
    MixerQualityLinear = 273
    MixerQualityCubic  = 274
  end
  fun get_mixer_gain = al_get_mixer_gain(mixer : Mixer) : LibC::Float
  fun get_mixer_playing = al_get_mixer_playing(mixer : Mixer) : LibC::Bool
  fun get_mixer_attached = al_get_mixer_attached(mixer : Mixer) : LibC::Bool
  fun set_mixer_frequency = al_set_mixer_frequency(mixer : Mixer, val : LibC::UInt) : LibC::Bool
  fun set_mixer_quality = al_set_mixer_quality(mixer : Mixer, val : MixerQuality) : LibC::Bool
  fun set_mixer_gain = al_set_mixer_gain(mixer : Mixer, gain : LibC::Float) : LibC::Bool
  fun set_mixer_playing = al_set_mixer_playing(mixer : Mixer, val : LibC::Bool) : LibC::Bool
  fun detach_mixer = al_detach_mixer(mixer : Mixer) : LibC::Bool
  fun create_voice = al_create_voice(freq : LibC::UInt, depth : AudioDepth, chan_conf : ChannelConf) : Voice
  type Voice = Void*
  fun destroy_voice = al_destroy_voice(voice : Voice)
  fun attach_sample_instance_to_voice = al_attach_sample_instance_to_voice(stream : SampleInstance, voice : Voice) : LibC::Bool
  fun attach_audio_stream_to_voice = al_attach_audio_stream_to_voice(stream : AudioStream, voice : Voice) : LibC::Bool
  fun attach_mixer_to_voice = al_attach_mixer_to_voice(mixer : Mixer, voice : Voice) : LibC::Bool
  fun detach_voice = al_detach_voice(voice : Voice)
  fun get_voice_frequency = al_get_voice_frequency(voice : Voice) : LibC::UInt
  fun get_voice_position = al_get_voice_position(voice : Voice) : LibC::UInt
  fun get_voice_channels = al_get_voice_channels(voice : Voice) : ChannelConf
  fun get_voice_depth = al_get_voice_depth(voice : Voice) : AudioDepth
  fun get_voice_playing = al_get_voice_playing(voice : Voice) : LibC::Bool
  fun set_voice_position = al_set_voice_position(voice : Voice, val : LibC::UInt) : LibC::Bool
  fun set_voice_playing = al_set_voice_playing(voice : Voice, val : LibC::Bool) : LibC::Bool
  fun install_audio = al_install_audio : LibC::Bool
  fun uninstall_audio = al_uninstall_audio
  fun is_audio_installed = al_is_audio_installed : LibC::Bool
  fun get_allegro_audio_version = al_get_allegro_audio_version : Uint32T
  fun get_channel_count = al_get_channel_count(conf : ChannelConf) : LibC::SizeT
  fun get_audio_depth_size = al_get_audio_depth_size(conf : AudioDepth) : LibC::SizeT
  fun fill_silence = al_fill_silence(buf : Void*, samples : LibC::UInt, depth : AudioDepth, chan_conf : ChannelConf)
  fun reserve_samples = al_reserve_samples(reserve_samples : LibC::Int) : LibC::Bool
  fun get_default_mixer = al_get_default_mixer : Mixer
  fun set_default_mixer = al_set_default_mixer(mixer : Mixer) : LibC::Bool
  fun restore_default_mixer = al_restore_default_mixer : LibC::Bool
  fun play_sample = al_play_sample(data : Sample, gain : LibC::Float, pan : LibC::Float, speed : LibC::Float, loop : Playmode, ret_id : SampleId*) : LibC::Bool
  fun stop_sample = al_stop_sample(spl_id : SampleId*)
  fun stop_samples = al_stop_samples
  fun get_default_voice = al_get_default_voice : Voice
  fun set_default_voice = al_set_default_voice(voice : Voice)
  fun register_sample_loader = al_register_sample_loader(ext : LibC::Char*, loader : (LibC::Char* -> Sample)) : LibC::Bool
  fun register_sample_saver = al_register_sample_saver(ext : LibC::Char*, saver : (LibC::Char*, Sample -> LibC::Bool)) : LibC::Bool
  fun register_audio_stream_loader = al_register_audio_stream_loader(ext : LibC::Char*, stream_loader : (LibC::Char*, LibC::SizeT, LibC::UInt -> AudioStream)) : LibC::Bool
  fun register_sample_loader_f = al_register_sample_loader_f(ext : LibC::Char*, loader : (File -> Sample)) : LibC::Bool
  fun register_sample_saver_f = al_register_sample_saver_f(ext : LibC::Char*, saver : (File, Sample -> LibC::Bool)) : LibC::Bool
  fun register_audio_stream_loader_f = al_register_audio_stream_loader_f(ext : LibC::Char*, stream_loader : (File, LibC::SizeT, LibC::UInt -> AudioStream)) : LibC::Bool
  fun load_sample = al_load_sample(filename : LibC::Char*) : Sample
  fun save_sample = al_save_sample(filename : LibC::Char*, spl : Sample) : LibC::Bool
  fun load_audio_stream = al_load_audio_stream(filename : LibC::Char*, buffer_count : LibC::SizeT, samples : LibC::UInt) : AudioStream
  fun load_sample_f = al_load_sample_f(fp : File, ident : LibC::Char*) : Sample
  fun save_sample_f = al_save_sample_f(fp : File, ident : LibC::Char*, spl : Sample) : LibC::Bool
  fun load_audio_stream_f = al_load_audio_stream_f(fp : File, ident : LibC::Char*, buffer_count : LibC::SizeT, samples : LibC::UInt) : AudioStream
  fun init_acodec_addon = al_init_acodec_addon : LibC::Bool
  fun get_allegro_acodec_version = al_get_allegro_acodec_version : Uint32T
  fun get_allegro_color_version = al_get_allegro_color_version : Uint32T
  fun color_hsv_to_rgb = al_color_hsv_to_rgb(hue : LibC::Float, saturation : LibC::Float, value : LibC::Float, red : LibC::Float*, green : LibC::Float*, blue : LibC::Float*)
  fun color_rgb_to_hsl = al_color_rgb_to_hsl(red : LibC::Float, green : LibC::Float, blue : LibC::Float, hue : LibC::Float*, saturation : LibC::Float*, lightness : LibC::Float*)
  fun color_rgb_to_hsv = al_color_rgb_to_hsv(red : LibC::Float, green : LibC::Float, blue : LibC::Float, hue : LibC::Float*, saturation : LibC::Float*, value : LibC::Float*)
  fun color_hsl_to_rgb = al_color_hsl_to_rgb(hue : LibC::Float, saturation : LibC::Float, lightness : LibC::Float, red : LibC::Float*, green : LibC::Float*, blue : LibC::Float*)
  fun color_name_to_rgb = al_color_name_to_rgb(name : LibC::Char*, r : LibC::Float*, g : LibC::Float*, b : LibC::Float*) : LibC::Bool
  fun color_rgb_to_name = al_color_rgb_to_name(r : LibC::Float, g : LibC::Float, b : LibC::Float) : LibC::Char*
  fun color_cmyk_to_rgb = al_color_cmyk_to_rgb(cyan : LibC::Float, magenta : LibC::Float, yellow : LibC::Float, key : LibC::Float, red : LibC::Float*, green : LibC::Float*, blue : LibC::Float*)
  fun color_rgb_to_cmyk = al_color_rgb_to_cmyk(red : LibC::Float, green : LibC::Float, blue : LibC::Float, cyan : LibC::Float*, magenta : LibC::Float*, yellow : LibC::Float*, key : LibC::Float*)
  fun color_yuv_to_rgb = al_color_yuv_to_rgb(y : LibC::Float, u : LibC::Float, v : LibC::Float, red : LibC::Float*, green : LibC::Float*, blue : LibC::Float*)
  fun color_rgb_to_yuv = al_color_rgb_to_yuv(red : LibC::Float, green : LibC::Float, blue : LibC::Float, y : LibC::Float*, u : LibC::Float*, v : LibC::Float*)
  fun color_rgb_to_html = al_color_rgb_to_html(red : LibC::Float, green : LibC::Float, blue : LibC::Float, string : LibC::Char*)
  fun color_html_to_rgb = al_color_html_to_rgb(string : LibC::Char*, red : LibC::Float*, green : LibC::Float*, blue : LibC::Float*) : LibC::Bool
  fun color_yuv = al_color_yuv(y : LibC::Float, u : LibC::Float, v : LibC::Float) : Color
  fun color_cmyk = al_color_cmyk(c : LibC::Float, m : LibC::Float, y : LibC::Float, k : LibC::Float) : Color
  fun color_hsl = al_color_hsl(h : LibC::Float, s : LibC::Float, l : LibC::Float) : Color
  fun color_hsv = al_color_hsv(h : LibC::Float, s : LibC::Float, v : LibC::Float) : Color
  fun color_name = al_color_name(name : LibC::Char*) : Color
  fun color_html = al_color_html(string : LibC::Char*) : Color
  fun color_xyz_to_rgb = al_color_xyz_to_rgb(x : LibC::Float, y : LibC::Float, z : LibC::Float, red : LibC::Float*, green : LibC::Float*, blue : LibC::Float*)
  fun color_rgb_to_xyz = al_color_rgb_to_xyz(red : LibC::Float, green : LibC::Float, blue : LibC::Float, x : LibC::Float*, y : LibC::Float*, z : LibC::Float*)
  fun color_xyz = al_color_xyz(x : LibC::Float, y : LibC::Float, z : LibC::Float) : Color
  fun color_lab_to_rgb = al_color_lab_to_rgb(l : LibC::Float, a : LibC::Float, b : LibC::Float, red : LibC::Float*, green : LibC::Float*, blue : LibC::Float*)
  fun color_rgb_to_lab = al_color_rgb_to_lab(red : LibC::Float, green : LibC::Float, blue : LibC::Float, l : LibC::Float*, a : LibC::Float*, b : LibC::Float*)
  fun color_lab = al_color_lab(l : LibC::Float, a : LibC::Float, b : LibC::Float) : Color
  fun color_xyy_to_rgb = al_color_xyy_to_rgb(x : LibC::Float, y : LibC::Float, y2 : LibC::Float, red : LibC::Float*, green : LibC::Float*, blue : LibC::Float*)
  fun color_rgb_to_xyy = al_color_rgb_to_xyy(red : LibC::Float, green : LibC::Float, blue : LibC::Float, x : LibC::Float*, y : LibC::Float*, y2 : LibC::Float*)
  fun color_xyy = al_color_xyy(x : LibC::Float, y : LibC::Float, y2 : LibC::Float) : Color
  fun color_distance_ciede2000 = al_color_distance_ciede2000(c1 : Color, c2 : Color) : LibC::Double
  fun color_lch_to_rgb = al_color_lch_to_rgb(l : LibC::Float, c : LibC::Float, h : LibC::Float, red : LibC::Float*, green : LibC::Float*, blue : LibC::Float*)
  fun color_rgb_to_lch = al_color_rgb_to_lch(red : LibC::Float, green : LibC::Float, blue : LibC::Float, l : LibC::Float*, c : LibC::Float*, h : LibC::Float*)
  fun color_lch = al_color_lch(l : LibC::Float, c : LibC::Float, h : LibC::Float) : Color
  fun is_color_valid = al_is_color_valid(color : Color) : LibC::Bool
  fun init_image_addon = al_init_image_addon : LibC::Bool
  fun shutdown_image_addon = al_shutdown_image_addon
  fun get_allegro_image_version = al_get_allegro_image_version : Uint32T
  NoKerning    = -1_i64
  AlignLeft    =  0_i64
  AlignCentre  =  1_i64
  AlignCenter  =  1_i64
  AlignRight   =  2_i64
  AlignInteger =  4_i64
  fun register_font_loader = al_register_font_loader(ext : LibC::Char*, load : (LibC::Char*, LibC::Int, LibC::Int -> Font)) : LibC::Bool
  type Font = Void*
  fun load_bitmap_font = al_load_bitmap_font(filename : LibC::Char*) : Font
  fun load_bitmap_font_flags = al_load_bitmap_font_flags(filename : LibC::Char*, flags : LibC::Int) : Font
  fun load_font = al_load_font(filename : LibC::Char*, size : LibC::Int, flags : LibC::Int) : Font
  fun grab_font_from_bitmap = al_grab_font_from_bitmap(bmp : Bitmap, n : LibC::Int, ranges : LibC::Int*) : Font
  fun create_builtin_font = al_create_builtin_font : Font
  fun draw_ustr = al_draw_ustr(font : Font, color : Color, x : LibC::Float, y : LibC::Float, flags : LibC::Int, ustr : Ustr*)
  fun draw_text = al_draw_text(font : Font, color : Color, x : LibC::Float, y : LibC::Float, flags : LibC::Int, text : LibC::Char*)
  fun draw_justified_text = al_draw_justified_text(font : Font, color : Color, x1 : LibC::Float, x2 : LibC::Float, y : LibC::Float, diff : LibC::Float, flags : LibC::Int, text : LibC::Char*)
  fun draw_justified_ustr = al_draw_justified_ustr(font : Font, color : Color, x1 : LibC::Float, x2 : LibC::Float, y : LibC::Float, diff : LibC::Float, flags : LibC::Int, text : Ustr*)
  fun draw_textf = al_draw_textf(font : Font, color : Color, x : LibC::Float, y : LibC::Float, flags : LibC::Int, format : LibC::Char*, ...)
  fun draw_justified_textf = al_draw_justified_textf(font : Font, color : Color, x1 : LibC::Float, x2 : LibC::Float, y : LibC::Float, diff : LibC::Float, flags : LibC::Int, format : LibC::Char*, ...)
  fun get_text_width = al_get_text_width(f : Font, str : LibC::Char*) : LibC::Int
  fun get_ustr_width = al_get_ustr_width(f : Font, ustr : Ustr*) : LibC::Int
  fun get_font_line_height = al_get_font_line_height(f : Font) : LibC::Int
  fun get_font_ascent = al_get_font_ascent(f : Font) : LibC::Int
  fun get_font_descent = al_get_font_descent(f : Font) : LibC::Int
  fun destroy_font = al_destroy_font(f : Font)
  fun get_ustr_dimensions = al_get_ustr_dimensions(f : Font, text : Ustr*, bbx : LibC::Int*, bby : LibC::Int*, bbw : LibC::Int*, bbh : LibC::Int*)
  fun get_text_dimensions = al_get_text_dimensions(f : Font, text : LibC::Char*, bbx : LibC::Int*, bby : LibC::Int*, bbw : LibC::Int*, bbh : LibC::Int*)
  fun init_font_addon = al_init_font_addon : LibC::Bool
  fun shutdown_font_addon = al_shutdown_font_addon
  fun get_allegro_font_version = al_get_allegro_font_version : Uint32T
  fun get_font_ranges = al_get_font_ranges(font : Font, ranges_count : LibC::Int, ranges : LibC::Int*) : LibC::Int
  fun draw_glyph = al_draw_glyph(font : Font, color : Color, x : LibC::Float, y : LibC::Float, codepoint : LibC::Int)
  fun get_glyph_width = al_get_glyph_width(f : Font, codepoint : LibC::Int) : LibC::Int
  fun get_glyph_dimensions = al_get_glyph_dimensions(f : Font, codepoint : LibC::Int, bbx : LibC::Int*, bby : LibC::Int*, bbw : LibC::Int*, bbh : LibC::Int*) : LibC::Bool
  fun get_glyph_advance = al_get_glyph_advance(f : Font, codepoint1 : LibC::Int, codepoint2 : LibC::Int) : LibC::Int
  fun draw_multiline_text = al_draw_multiline_text(font : Font, color : Color, x : LibC::Float, y : LibC::Float, max_width : LibC::Float, line_height : LibC::Float, flags : LibC::Int, text : LibC::Char*)
  fun draw_multiline_textf = al_draw_multiline_textf(font : Font, color : Color, x : LibC::Float, y : LibC::Float, max_width : LibC::Float, line_height : LibC::Float, flags : LibC::Int, format : LibC::Char*, ...)
  fun draw_multiline_ustr = al_draw_multiline_ustr(font : Font, color : Color, x : LibC::Float, y : LibC::Float, max_width : LibC::Float, line_height : LibC::Float, flags : LibC::Int, text : Ustr*)
  fun do_multiline_text = al_do_multiline_text(font : Font, max_width : LibC::Float, text : LibC::Char*, cb : (LibC::Int, LibC::Char*, LibC::Int, Void* -> LibC::Bool), extra : Void*)
  fun do_multiline_ustr = al_do_multiline_ustr(font : Font, max_width : LibC::Float, ustr : Ustr*, cb : (LibC::Int, Ustr*, Void* -> LibC::Bool), extra : Void*)
  fun set_fallback_font = al_set_fallback_font(font : Font, fallback : Font)
  fun get_fallback_font = al_get_fallback_font(font : Font) : Font

  struct MenuInfo
    caption : LibC::Char*
    id : Uint16T
    flags : LibC::Int
    icon : Bitmap
  end

  fun init_native_dialog_addon = al_init_native_dialog_addon : LibC::Bool
  fun shutdown_native_dialog_addon = al_shutdown_native_dialog_addon
  fun create_native_file_dialog = al_create_native_file_dialog(initial_path : LibC::Char*, title : LibC::Char*, patterns : LibC::Char*, mode : LibC::Int) : Filechooser
  type Filechooser = Void*
  fun show_native_file_dialog = al_show_native_file_dialog(display : Display*, dialog : Filechooser) : LibC::Bool
  fun get_native_file_dialog_count = al_get_native_file_dialog_count(dialog : Filechooser) : LibC::Int
  fun get_native_file_dialog_path = al_get_native_file_dialog_path(dialog : Filechooser, index : LibC::SizeT) : LibC::Char*
  fun destroy_native_file_dialog = al_destroy_native_file_dialog(dialog : Filechooser)
  fun show_native_message_box = al_show_native_message_box(display : Display*, title : LibC::Char*, heading : LibC::Char*, text : LibC::Char*, buttons : LibC::Char*, flags : LibC::Int) : LibC::Int
  fun open_native_text_log = al_open_native_text_log(title : LibC::Char*, flags : LibC::Int) : Textlog
  type Textlog = Void*
  fun close_native_text_log = al_close_native_text_log(textlog : Textlog)
  fun append_native_text_log = al_append_native_text_log(textlog : Textlog, format : LibC::Char*, ...)
  fun get_native_text_log_event_source = al_get_native_text_log_event_source(textlog : Textlog) : EventSource*
  fun create_menu = al_create_menu : Menu
  type Menu = Void*
  fun create_popup_menu = al_create_popup_menu : Menu
  fun build_menu = al_build_menu(info : MenuInfo*) : Menu
  fun append_menu_item = al_append_menu_item(parent : Menu, title : LibC::Char*, id : Uint16T, flags : LibC::Int, icon : Bitmap, submenu : Menu) : LibC::Int
  fun insert_menu_item = al_insert_menu_item(parent : Menu, pos : LibC::Int, title : LibC::Char*, id : Uint16T, flags : LibC::Int, icon : Bitmap, submenu : Menu) : LibC::Int
  fun remove_menu_item = al_remove_menu_item(menu : Menu, pos : LibC::Int) : LibC::Bool
  fun clone_menu = al_clone_menu(menu : Menu) : Menu
  fun clone_menu_for_popup = al_clone_menu_for_popup(menu : Menu) : Menu
  fun destroy_menu = al_destroy_menu(menu : Menu)
  fun get_menu_item_caption = al_get_menu_item_caption(menu : Menu, pos : LibC::Int) : LibC::Char*
  fun set_menu_item_caption = al_set_menu_item_caption(menu : Menu, pos : LibC::Int, caption : LibC::Char*)
  fun get_menu_item_flags = al_get_menu_item_flags(menu : Menu, pos : LibC::Int) : LibC::Int
  fun set_menu_item_flags = al_set_menu_item_flags(menu : Menu, pos : LibC::Int, flags : LibC::Int)
  fun get_menu_item_icon = al_get_menu_item_icon(menu : Menu, pos : LibC::Int) : Bitmap
  fun set_menu_item_icon = al_set_menu_item_icon(menu : Menu, pos : LibC::Int, icon : Bitmap)
  fun find_menu = al_find_menu(haystack : Menu, id : Uint16T) : Menu
  fun find_menu_item = al_find_menu_item(haystack : Menu, id : Uint16T, menu : Menu*, index : LibC::Int*) : LibC::Bool
  fun get_default_menu_event_source = al_get_default_menu_event_source : EventSource*
  fun enable_menu_event_source = al_enable_menu_event_source(menu : Menu) : EventSource*
  fun disable_menu_event_source = al_disable_menu_event_source(menu : Menu)
  fun get_display_menu = al_get_display_menu(display : Display*) : Menu
  fun set_display_menu = al_set_display_menu(display : Display*, menu : Menu) : LibC::Bool
  fun popup_menu = al_popup_menu(popup : Menu, display : Display*) : LibC::Bool
  fun remove_display_menu = al_remove_display_menu(display : Display*) : Menu
  fun get_allegro_native_dialog_version = al_get_allegro_native_dialog_version : Uint32T
  FilechooserFileMustExist =   1_i64
  FilechooserSave          =   2_i64
  FilechooserFolder        =   4_i64
  FilechooserPictures      =   8_i64
  FilechooserShowHidden    =  16_i64
  FilechooserMultiple      =  32_i64
  MessageboxWarn           =   1_i64
  MessageboxError          =   2_i64
  MessageboxOkCancel       =   4_i64
  MessageboxYesNo          =   8_i64
  MessageboxQuestion       =  16_i64
  TextlogNoClose           =   1_i64
  TextlogMonospace         =   2_i64
  EventNativeDialogClose   = 600_i64
  EventMenuClick           = 601_i64
  MenuItemEnabled          =   0_i64
  MenuItemCheckbox         =   1_i64
  MenuItemChecked          =   2_i64
  MenuItemDisabled         =   4_i64
  PrimMaxUserAttr          =  10_i64

  struct VertexElement
    attribute : LibC::Int
    storage : LibC::Int
    offset : LibC::Int
  end


  struct Vertex
    x : LibC::Float
    y : LibC::Float
    z : LibC::Float
    u : LibC::Float
    v : LibC::Float
    color : Color
  end

  fun get_allegro_primitives_version = al_get_allegro_primitives_version : Uint32T
  fun init_primitives_addon = al_init_primitives_addon : LibC::Bool
  fun shutdown_primitives_addon = al_shutdown_primitives_addon
  fun draw_prim = al_draw_prim(vtxs : Void*, decl : VertexDecl, texture : Bitmap, start : LibC::Int, _end : LibC::Int, type : LibC::Int) : LibC::Int
  type VertexDecl = Void*
  fun draw_indexed_prim = al_draw_indexed_prim(vtxs : Void*, decl : VertexDecl, texture : Bitmap, indices : LibC::Int*, num_vtx : LibC::Int, type : LibC::Int) : LibC::Int
  fun draw_vertex_buffer = al_draw_vertex_buffer(vertex_buffer : VertexBuffer, texture : Bitmap, start : LibC::Int, _end : LibC::Int, type : LibC::Int) : LibC::Int
  type VertexBuffer = Void*
  fun draw_indexed_buffer = al_draw_indexed_buffer(vertex_buffer : VertexBuffer, texture : Bitmap, index_buffer : IndexBuffer, start : LibC::Int, _end : LibC::Int, type : LibC::Int) : LibC::Int
  type IndexBuffer = Void*
  fun create_vertex_decl = al_create_vertex_decl(elements : VertexElement*, stride : LibC::Int) : VertexDecl
  fun destroy_vertex_decl = al_destroy_vertex_decl(decl : VertexDecl)
  fun create_vertex_buffer = al_create_vertex_buffer(decl : VertexDecl, initial_data : Void*, num_vertices : LibC::Int, flags : LibC::Int) : VertexBuffer
  fun destroy_vertex_buffer = al_destroy_vertex_buffer(buffer : VertexBuffer)
  fun lock_vertex_buffer = al_lock_vertex_buffer(buffer : VertexBuffer, offset : LibC::Int, length : LibC::Int, flags : LibC::Int) : Void*
  fun unlock_vertex_buffer = al_unlock_vertex_buffer(buffer : VertexBuffer)
  fun get_vertex_buffer_size = al_get_vertex_buffer_size(buffer : VertexBuffer) : LibC::Int
  fun create_index_buffer = al_create_index_buffer(index_size : LibC::Int, initial_data : Void*, num_indices : LibC::Int, flags : LibC::Int) : IndexBuffer
  fun destroy_index_buffer = al_destroy_index_buffer(buffer : IndexBuffer)
  fun lock_index_buffer = al_lock_index_buffer(buffer : IndexBuffer, offset : LibC::Int, length : LibC::Int, flags : LibC::Int) : Void*
  fun unlock_index_buffer = al_unlock_index_buffer(buffer : IndexBuffer)
  fun get_index_buffer_size = al_get_index_buffer_size(buffer : IndexBuffer) : LibC::Int
  fun triangulate_polygon = al_triangulate_polygon(vertices : LibC::Float*, vertex_stride : LibC::SizeT, vertex_counts : LibC::Int*, emit_triangle : (LibC::Int, LibC::Int, LibC::Int, Void* -> Void), userdata : Void*) : LibC::Bool
  fun draw_soft_triangle = al_draw_soft_triangle(v1 : Vertex*, v2 : Vertex*, v3 : Vertex*, state : UintptrT, init : (UintptrT, Vertex*, Vertex*, Vertex* -> Void), first : (UintptrT, LibC::Int, LibC::Int, LibC::Int, LibC::Int -> Void), step : (UintptrT, LibC::Int -> Void), draw : (UintptrT, LibC::Int, LibC::Int, LibC::Int -> Void))
  alias UintptrT = LibC::ULong
  fun draw_soft_line = al_draw_soft_line(v1 : Vertex*, v2 : Vertex*, state : UintptrT, first : (UintptrT, LibC::Int, LibC::Int, Vertex*, Vertex* -> Void), step : (UintptrT, LibC::Int -> Void), draw : (UintptrT, LibC::Int, LibC::Int -> Void))
  fun draw_line = al_draw_line(x1 : LibC::Float, y1 : LibC::Float, x2 : LibC::Float, y2 : LibC::Float, color : Color, thickness : LibC::Float)
  fun draw_triangle = al_draw_triangle(x1 : LibC::Float, y1 : LibC::Float, x2 : LibC::Float, y2 : LibC::Float, x3 : LibC::Float, y3 : LibC::Float, color : Color, thickness : LibC::Float)
  fun draw_rectangle = al_draw_rectangle(x1 : LibC::Float, y1 : LibC::Float, x2 : LibC::Float, y2 : LibC::Float, color : Color, thickness : LibC::Float)
  fun draw_rounded_rectangle = al_draw_rounded_rectangle(x1 : LibC::Float, y1 : LibC::Float, x2 : LibC::Float, y2 : LibC::Float, rx : LibC::Float, ry : LibC::Float, color : Color, thickness : LibC::Float)
  fun calculate_arc = al_calculate_arc(dest : LibC::Float*, stride : LibC::Int, cx : LibC::Float, cy : LibC::Float, rx : LibC::Float, ry : LibC::Float, start_theta : LibC::Float, delta_theta : LibC::Float, thickness : LibC::Float, num_points : LibC::Int)
  fun draw_circle = al_draw_circle(cx : LibC::Float, cy : LibC::Float, r : LibC::Float, color : Color, thickness : LibC::Float)
  fun draw_ellipse = al_draw_ellipse(cx : LibC::Float, cy : LibC::Float, rx : LibC::Float, ry : LibC::Float, color : Color, thickness : LibC::Float)
  fun draw_arc = al_draw_arc(cx : LibC::Float, cy : LibC::Float, r : LibC::Float, start_theta : LibC::Float, delta_theta : LibC::Float, color : Color, thickness : LibC::Float)
  fun draw_elliptical_arc = al_draw_elliptical_arc(cx : LibC::Float, cy : LibC::Float, rx : LibC::Float, ry : LibC::Float, start_theta : LibC::Float, delta_theta : LibC::Float, color : Color, thickness : LibC::Float)
  fun draw_pieslice = al_draw_pieslice(cx : LibC::Float, cy : LibC::Float, r : LibC::Float, start_theta : LibC::Float, delta_theta : LibC::Float, color : Color, thickness : LibC::Float)
  fun calculate_spline = al_calculate_spline(dest : LibC::Float*, stride : LibC::Int, points : LibC::Float[8], thickness : LibC::Float, num_segments : LibC::Int)
  fun draw_spline = al_draw_spline(points : LibC::Float[8], color : Color, thickness : LibC::Float)
  fun calculate_ribbon = al_calculate_ribbon(dest : LibC::Float*, dest_stride : LibC::Int, points : LibC::Float*, points_stride : LibC::Int, thickness : LibC::Float, num_segments : LibC::Int)
  fun draw_ribbon = al_draw_ribbon(points : LibC::Float*, points_stride : LibC::Int, color : Color, thickness : LibC::Float, num_segments : LibC::Int)
  fun draw_filled_triangle = al_draw_filled_triangle(x1 : LibC::Float, y1 : LibC::Float, x2 : LibC::Float, y2 : LibC::Float, x3 : LibC::Float, y3 : LibC::Float, color : Color)
  fun draw_filled_rectangle = al_draw_filled_rectangle(x1 : LibC::Float, y1 : LibC::Float, x2 : LibC::Float, y2 : LibC::Float, color : Color)
  fun draw_filled_ellipse = al_draw_filled_ellipse(cx : LibC::Float, cy : LibC::Float, rx : LibC::Float, ry : LibC::Float, color : Color)
  fun draw_filled_circle = al_draw_filled_circle(cx : LibC::Float, cy : LibC::Float, r : LibC::Float, color : Color)
  fun draw_filled_pieslice = al_draw_filled_pieslice(cx : LibC::Float, cy : LibC::Float, r : LibC::Float, start_theta : LibC::Float, delta_theta : LibC::Float, color : Color)
  fun draw_filled_rounded_rectangle = al_draw_filled_rounded_rectangle(x1 : LibC::Float, y1 : LibC::Float, x2 : LibC::Float, y2 : LibC::Float, rx : LibC::Float, ry : LibC::Float, color : Color)
  fun draw_polyline = al_draw_polyline(vertices : LibC::Float*, vertex_stride : LibC::Int, vertex_count : LibC::Int, join_style : LibC::Int, cap_style : LibC::Int, color : Color, thickness : LibC::Float, miter_limit : LibC::Float)
  fun draw_polygon = al_draw_polygon(vertices : LibC::Float*, vertex_count : LibC::Int, join_style : LibC::Int, color : Color, thickness : LibC::Float, miter_limit : LibC::Float)
  fun draw_filled_polygon = al_draw_filled_polygon(vertices : LibC::Float*, vertex_count : LibC::Int, color : Color)
  fun draw_filled_polygon_with_holes = al_draw_filled_polygon_with_holes(vertices : LibC::Float*, vertex_counts : LibC::Int*, color : Color)
  $_user_assert_handler : (LibC::Char*, LibC::Char*, LibC::Int, LibC::Char* -> Void)
  $fixtorad_r : Fixed
  $radtofix_r : Fixed
  $_fix_cos_tbl : Fixed*
  $_fix_tan_tbl : Fixed*
  $_fix_acos_tbl : Fixed*
end
