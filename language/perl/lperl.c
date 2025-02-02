#include <EXTERN.h>
#include <perl.h>

#ifdef WIN32
  #define CALLING_CONVENTION __stdcall
#else
  #define CALLING_CONVENTION
#endif

#if DEBUG
  #define DEBUG_PRINT(str) (puts(str));
#else
  #define DEBUG_PRINT(str) 
#endif

static PerlInterpreter *my_perl = NULL;  

/* this is needed to for 'use AnyModule' to work */
EXTERN_C void boot_DynaLoader (pTHX_ CV* cv);
EXTERN_C void xs_init(pTHX){
	char *file = __FILE__;
	dXSUB_SYS;
	newXS("DynaLoader::boot_DynaLoader", boot_DynaLoader, file); }

PerlInterpreter* CALLING_CONVENTION lperl_get_interpreter(){
  return PERL_GET_THX; }

SV* CALLING_CONVENTION lperl_sv_bless( SV *rv, HV *stash ){
  return sv_bless(rv, stash); }

SV* CALLING_CONVENTION lperl_get_PL_sv_undef() {
  /*
  printf("SIZE OF BOOL = %d\n", CHAR_BIT*sizeof(bool));
  printf("SIZE OF INT = %d\n", CHAR_BIT*sizeof(int));
  printf("XXXX = %d\n", SvOK(&PL_sv_undef));
  */
  return &PL_sv_undef; }

void CALLING_CONVENTION lperl_sv_setsv(SV *dest, SV *source){
  sv_setsv(dest, source); }

SV* CALLING_CONVENTION lperl_sv_newmortal(){
  return sv_newmortal(); }

void CALLING_CONVENTION lperl_sv_setnv( SV *sv, double *value ){
  sv_setnv(sv, *value); /*  deref  */ }

void CALLING_CONVENTION lperl_sv_dump(SV *sv){
  sv_dump(sv); }

void CALLING_CONVENTION lperl_dump_markstack_ptr(){
  printf("markstack_ptr: %x\n", PL_markstack_ptr); }

void CALLING_CONVENTION lperl_dump_stack_sp(){
  printf("stack_sp: %x\n", PL_stack_sp); }

void* CALLING_CONVENTION lperl_get_markstack_ptr(){
  return PL_markstack_ptr; }

void CALLING_CONVENTION lperl_set_markstack_ptr( void *addr ){
  PL_markstack_ptr = (I32*) addr; }

void CALLING_CONVENTION lperl_gv_dump( GV *gv ){
  gv_dump(gv); }

CV* CALLING_CONVENTION lperl_newXS( char *name, XSUBADDR_t function, char *filename ){
  DEBUG_PRINT("in lperl_newXS");
  return newXS(name, function, filename); }

void CALLING_CONVENTION lperl_prepare_old(){
  char *embedding[] = { "", "-e", "0" };
  if ( my_perl != NULL ) 
    return;
  my_perl = perl_alloc();
  perl_construct(my_perl);
  perl_parse(my_perl, xs_init, 3, embedding, (char **)NULL); }

SV* CALLING_CONVENTION lperl_eval_pv(char *str, long int croak_on_error ){
  return eval_pv(str, croak_on_error); }

int CALLING_CONVENTION lperl_call_pv( char *str, int flags ){
  return perl_call_pv(str, flags); }

int CALLING_CONVENTION lperl_call_method( char *str, int flags ){
  return perl_call_method(str, flags); }

SV* CALLING_CONVENTION lperl_sv_2mortal( SV* sv ){
  DEBUG_PRINT("in lperl_sv_2mortal");
  return sv_2mortal(sv); }

SV* CALLING_CONVENTION lperl_newSViv( int x ){
  return newSViv(x); }

SV* CALLING_CONVENTION lperl_newSVsv( SV *source ){
  return newSVsv(source); }

SV* CALLING_CONVENTION lperl_newSVpv( char *str, int len ){
  return newSVpv(str, len); }

SV* CALLING_CONVENTION lperl_newSV(){
  return newSVsv(&PL_sv_undef); }

void CALLING_CONVENTION lperl_sv_setiv( SV *sv, I32 number ){
  sv_setiv(sv,number); }

void CALLING_CONVENTION lperl_sv_setpv( SV *sv, char *str ){
  sv_setpv(sv, str); }

SV* CALLING_CONVENTION lperl_SvRV( SV *sv ){
  return SvRV(sv); }

char * CALLING_CONVENTION lperl_SvPV_nolen( SV *sv ){
  return SvPV_nolen(sv); }

SV* CALLING_CONVENTION lperl_SvREFCNT_inc( SV *sv ){
  return SvREFCNT_inc(sv); }

void CALLING_CONVENTION lperl_SvREFCNT_dec( SV *sv ){
  SvREFCNT_dec(sv); }

I32 CALLING_CONVENTION lperl_SvIV( SV *sv ){
  return SvIV(sv); }

I32 CALLING_CONVENTION lperl_sv_cmp( SV *sv1, SV *sv2 ){
  return sv_cmp(sv1,sv2); }

void CALLING_CONVENTION lperl_sv2nv( SV *sv, double *placeholder ){
  /* it is convoluted because Pliant handles Float's by reference  */
  *placeholder = SvNV(sv); }

long int CALLING_CONVENTION lperl_eval_sv( SV *sv, long int croak_on_error ){
  return eval_sv(sv, croak_on_error); }

AV* CALLING_CONVENTION lperl_get_av( char *varname, int flag ){
  AV* tmp = get_av(varname, flag);
  return tmp; }

SV* CALLING_CONVENTION lperl_av_pop( AV* av ){
  return av_pop(av); }

HV* CALLING_CONVENTION lperl_get_hv( char *varname, int flag ){
  return perl_get_hv(varname, flag); }

HV* CALLING_CONVENTION lperl_gv_stashpv( char *varname, int flag ){
  return gv_stashpv(varname, flag); }

void CALLING_CONVENTION lperl_cleanup( PerlInterpreter *perl_interpreter ){
  DEBUG_PRINT("in lperl_cleanup\n");
  perl_destruct(perl_interpreter);
  DEBUG_PRINT("  destructed: ok\n");
  perl_free(perl_interpreter);
  DEBUG_PRINT("  DONE\n"); }

void CALLING_CONVENTION lperl_cleanup_old(){
  lperl_cleanup(my_perl); }

SV* CALLING_CONVENTION lperl_newRV_inc( SV* thing ){
  SV *retval = newRV_inc(thing);
  return retval; }

AV* CALLING_CONVENTION lperl_newAV(){
  AV *retval = newAV();
  return retval; }

HV* CALLING_CONVENTION lperl_newHV(){
  HV *retval = newHV();
  return retval; }

SV** CALLING_CONVENTION lperl_av_fetch( AV *av, I32 index,I32 flag ){
  return av_fetch(av, index, flag); }

SV** CALLING_CONVENTION lperl_hv_fetch( HV *hv, char *key, I32 klen, I32 lval ){
  return hv_fetch(hv, key, klen, lval); }

SV** CALLING_CONVENTION lperl_av_store( AV* av,I32 index,SV* val ){
  SV** retval;
  retval = av_store(av, index, val);
  return  retval; }

SV** CALLING_CONVENTION lperl_hv_store( HV* hv,char *key, I32 klen,SV* val, I32 hash ){
  return hv_store(hv, key, klen, val, 0); }

I32 CALLING_CONVENTION lperl_hv_iterinit( HV* hv ){
  return hv_iterinit(hv); }

SV* CALLING_CONVENTION lperl_hv_iternextsv( HV* hv, char **key, I32 *pkeylen ){
  return hv_iternextsv(hv,key,pkeylen); }

int CALLING_CONVENTION lperl_av_len( AV* av ){
  long int len;
  short int tmp;
  len = av_len(av);
  tmp = (short int) len;
  return tmp; }

void CALLING_CONVENTION lperl_av_undef( AV* av ){
  av_undef(av); }


/* stack manipulation macro wrappers */

SV** CALLING_CONVENTION lperl__GET_STACK_SP(){ 
  DEBUG_PRINT("in lperl__GET_STACK_SP"); 
  return PL_stack_sp; }

void CALLING_CONVENTION lperl_ENTER(){ 
  DEBUG_PRINT("in lperl_ENTER");   
  ENTER; }

void CALLING_CONVENTION lperl_SAVETMPS(){ 
  DEBUG_PRINT("in lperl_SAVETMPS");
  SAVETMPS; }

void CALLING_CONVENTION lperl_FREETMPS(){ 
  DEBUG_PRINT("in lperl_FREETMPS");
  FREETMPS; }

void CALLING_CONVENTION lperl_LEAVE(){ 
  DEBUG_PRINT("in lperl_LEAVE");   
  LEAVE; }

void CALLING_CONVENTION lperl_PUSHMARK( SV ***mysp ){ 
  register SV** sp = *mysp; 
  DEBUG_PRINT("in lperl_PUSHMARK"); 
  PUSHMARK(sp);                   
  *mysp = sp; }

void CALLING_CONVENTION lperl_XPUSHs( SV ***mysp, SV *sv ){ 
  register SV** sp = *mysp; 
  EXTEND(sp,1); 
  DEBUG_PRINT("in lperl_XPUSHs");   
  (*++sp = (sv));   
  *mysp = sp; }

void CALLING_CONVENTION lperl_PUTBACK( SV ***mysp ){ 
  register SV** sp = *mysp; 
  DEBUG_PRINT("in lperl_PUTBACK");  
  PUTBACK;                        
  *mysp = sp; }

void CALLING_CONVENTION lperl_SPAGAIN( SV ***mysp ){ 
  register SV** sp = *mysp; 
  DEBUG_PRINT("in lperl_SPAGAIN");  
  SPAGAIN;                        
  *mysp = sp; }

SV*  CALLING_CONVENTION lperl_POPs( SV ***mysp ){ 
  register SV** sp = *mysp; 
  SV *sv; 
  DEBUG_PRINT("in lperl_POPs");      
  sv = POPs;             
  *mysp = sp; 
  return sv; }

int  CALLING_CONVENTION lperl_POPi( SV ***mysp ){ 
  register SV** sp = *mysp; 
  int val; 
  DEBUG_PRINT("in lperl_POPi");     
  val = POPi;            
  *mysp = sp; 
  return val; }

int  CALLING_CONVENTION lperl_EXTEND( SV ***mysp, SV **sp_user, int value ){ 
  register SV** sp = *mysp; 
  EXTEND(sp_user,value); 
  *mysp = sp; 
  return 1; }

int CALLING_CONVENTION lperl_TOPMARK(){ 
  return TOPMARK; }

int CALLING_CONVENTION lperl_POPMARK(){ 
  return POPMARK; }

SV** CALLING_CONVENTION lperl__GET_STACK_BASE(){ 
  return PL_stack_base; }

void CALLING_CONVENTION lperl__SET_STACK_SP( SV** ptr ){ 
  PL_stack_sp = ptr; }

/* main is required for windows DLL */
int main(){ 
  return 0; }

