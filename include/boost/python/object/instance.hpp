// Copyright David Abrahams 2002. Permission to copy, use,
// modify, sell and distribute this software is granted provided this
// copyright notice appears in all copies. This software is provided
// "as is" without express or implied warranty, and with no claim as
// to its suitability for any purpose.
#ifndef INSTANCE_DWA200295_HPP
# define INSTANCE_DWA200295_HPP

# include <boost/python/detail/wrap_python.hpp>
# include <boost/type_traits/alignment_traits.hpp>
# include <cstddef>

namespace boost { namespace python { namespace objects { 

// Each extension instance will be one of these
template <class Data = char>
struct instance
{
    PyObject_VAR_HEAD
    PyObject* dict;
    PyObject* weakrefs; 
    instance_holder* objects;

    BOOST_STATIC_CONSTANT(std::size_t, alignment = alignment_of<Data>::value);
    typedef typename type_with_alignment<alignment>::type align_t;
          
    union
    {
        align_t align;
        char bytes[sizeof(Data)];
    } storage;
};

template <class Data>
struct additional_instance_size
{
    typedef instance<Data> instance_data;
    typedef instance<char> instance_char;
    BOOST_STATIC_CONSTANT(
        std::size_t, value = sizeof(instance_data) - offsetof(instance_char,storage));
};

}}} // namespace boost::python::object

#endif // INSTANCE_DWA200295_HPP