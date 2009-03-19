"""
"""

cdef extern from "openssl/rc4.h":
    ctypedef struct RC4_KEY:
        pass

    void RC4_set_key(RC4_KEY *, int, unsigned char *)
    void c_RC4 "RC4"(RC4_KEY *, unsigned long, unsigned char *, unsigned char *)

cdef extern from "Python.h":
    void *PyMem_Malloc(Py_ssize_t n)
    void PyMem_Free(void *p)

    int PyString_AsStringAndSize(object, char **, Py_ssize_t *)
    object PyString_FromStringAndSize(char *, Py_ssize_t)


cdef class RC4:
    cdef RC4_KEY *cipher

    def __init__(self, key=None):
        self.cipher = <RC4_KEY *>PyMem_Malloc(sizeof(RC4_KEY))

        if self.cipher == NULL:
            raise MemoryError

        if key is not None:
            self.setKey(key)

    def __del__(self):
        if self.cipher != NULL:
            PyMem_Free(self.cipher)

    def setKey(self, key):
        cdef Py_ssize_t len
        cdef char *buf

        if PyString_AsStringAndSize(key, &buf, &len) == -1:
            return

        RC4_set_key(self.cipher, len, <unsigned char *>buf)

    def update(self, data):
        cdef Py_ssize_t len
        cdef char *input
        cdef char *output

        if PyString_AsStringAndSize(data, &input, &len) == -1:
            return

        output = <char *>PyMem_Malloc(len)
        c_RC4(self.cipher, len, <unsigned char *>input, <unsigned char *>output)

        ret = PyString_FromStringAndSize(output, len)
        PyMem_Free(output)

        return ret