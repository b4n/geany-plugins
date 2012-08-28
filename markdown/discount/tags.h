/* block-level tags for passing html blocks through the blender
 */
#ifndef _TAGS_D
#define _TAGS_D

struct kw {
    const char *id;
    int         size;
    int         selfclose;
} ;


struct kw* mkd_search_tags(const char *, int);
void mkd_deallocate_tags(void);
void mkd_sort_tags(void);
void mkd_define_tag(const char *, int);

#endif
